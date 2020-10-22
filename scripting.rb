# frozen_string_literal: true

require 'curb'
require 'nokogiri'
require 'active_support'
require 'json'
require 'digest'
require 'logger'

# module Scripting
module Scripting

  CACHE_FOLDER  = 'cache/'      # путь к кэшированным данным
  CACHE         = true          # флаг включения кэширования
  LOG_FILE      = 'parser.log'  # путь к файлу логов

  # Класс реализует загрузку страниц get и post запросами
  # с возможностью кэширования
  # TODO: ВНИМАНИЕ!!! нужно допилить редирект. т.е. если в ответе пришло 301, попытаться загрузить страницу редиректа
  class Loader
    # класс для отправки get и post запросов
    # для удобства на время разработки реализуем простое кэширование страниц, что бы при отладке не делать
    # запросы на сервер постоянно.
    attr_reader :requests_count, :from_cache_count

    # если нужно передавть какие-то особые заголовки, передаем их при создании загрузчика
    def initialize(headers = {})
      @headers = headers
      @requests_count = 0
      @from_cache_count = 0
      @logger = Logger.new(LOG_FILE, 'monthly')

      # достаем user-agent из файла 'user-agent'
      @user_agents = []
      open 'user-agent' do |f|
        while (line = f.gets)
          @user_agents << line.sub("\n", '')
        end
      end
    end

    def save_to_cache(file, content)
      # метод сохраняет данные в кэш
      file_path = CACHE_FOLDER + file
      open(file_path, 'w') do |f|
        f.puts content
      end
    end

    def cached?(file)
      file_path = CACHE_FOLDER + file
      File.exist?(file_path)
    end

    def get_from_cache(file)
      @from_cache_count += 1
      # метод достает данные из кэша
      file_path = CACHE_FOLDER + file
      # проверяем есть ли в кэше нужный файл и читаем его контент, иначе возвращаем nil
      File.exist?(file_path) ? open(file_path, 'r', &:read) : nil
    end

    def request(url, method = 'get', parameters = nil)
      # если запрос уже кэширован, достаем из кэша и возвращаем контент
      file_name = create_h1_filename(url, method, parameters)
      if cached?(file_name) && CACHE
        @logger.info("Page \"#{url.scan(%r{.+/([^/]+)/?})[0][0]}\" uploaded from cache")
        return { 'status' => 200, 'body' => get_from_cache(file_name) }
      end

      # если запрос не кэширован, делаем запрос на сервер и возвращаем результат
      @requests_count += 1
      response = method == 'get' ? get(url) : post(url, parameters)
      save_to_cache(file_name, response['body']) if response['status'] == 200 && CACHE
      response
    end

    # метод возвращает случайный user-agent из нашего набора
    def user_agent
      @user_agents.min_by { rand }
    end

    def on_success(url)
      @logger.info('Success: "' + url.scan(%r{.+/([^/]+)/?})[0][0] + '"')
    end

    def get(url)
      # метод реализует get запрос по урлу и возвращает хэш {статус, тело ответа}
      @logger.info('Send get request to: "' + url.scan(%r{.+/([^/]+)/?})[0][0] + '"')
      http = Curl::Easy.perform(url) do |curl|
        curl.on_success { on_success(url) }
      end
      { 'status' => http.status.to_i, 'body' => http.body }
    end

    # метод ля отправки post запроса. ВНИМАНИЕ!!! метод не тестировался, возможно он не работает
    def post(url, parameters)
      @logger.info('Send post request to: "' + url.scan(%r{.+/([^/]+)/?})[0][0] + '"')
      http = Curl::Easy.new do |curl|
        @headers['User-Agent'] = user_agent
        @headers.each do |key, value|
          curl.headers[key] = value if key.size.positive?
        end
        curl.on_success { on_success(url) }
      end
      http.set(:HTTP_VERSION, Curl::HTTP_2_0)
      http.post(url, Curl::PostField.content('params', parameters.join))
      { 'status' => http.status.to_i, 'body' => ActiveSupport::Gzip.decompress(http.body) }
    end

    def create_h1_filename(*params)
      Digest::SHA1.hexdigest(params.join)
    end

  end

  class Template
    # метод принимает url страницы для скачки.
    def initialize(url)
      @todo = { url: url }
      @context = nil
      @loader = Loader.new
    end

    # метод возвращает нейкий контекст,
    # я пока не знаю, что он передает целиком, но точно передает загруженную страницу, так и поступим
    def context
      response = @loader.request @todo[:url]
      { doc: Nokogiri::HTML(response['body']), body: response['body'] }
    end
  end

  class ParserContext
    attr_accessor :doc, :page_content, :products, :base_product

    def initialize(doc, page_content)
      @doc = doc
      @page_content = page_content
      @base_product = {}
      @products = []
    end

    def add_product(product)
      @products << product
    end

    def print_products
      p "Parsed #{@products.count} products"
      @products.each do |prd|
        p '-' * 100
        prd.each { |k, v| p '|%20s|%77s|' % [k, v.is_a?(Array) ? v.map! { |i| i[-8..-1] }.join(', ') : v] }
        p '_' * 100
        p ''
      end
    end
  end

  class CustomParser < Template

    NAME = 'name'
    PRICE = 'price'
    REGULAR_PRICE = 'regular_price'
    KEY = 'key'
    STOCK = 'stock'
    BREADCRUMB = 'breadcrumb'
    BRAND = 'brand'
    SKU = 'sku'
    IMAGE = 'image'
    ATTRS = 'attrs'

    # метод достает данные из nokogiri по правилам экстрактора для простых данных,
    # которые не требуют преобразований
    def prop(doc, xpath, reg_exp = /^.*$/)
      nodes = doc.xpath xpath
      result = nodes.text.scan reg_exp
      result[0]
    end

    # метод достает хлебные крошки и применяет паттерн
    def breadcrumbs(doc, xpath, reg_exp = /^(.*)$/)
      nodes = doc.xpath xpath + '//a'
      breadcrumbs = []
      nodes.each { |a| breadcrumbs << a.text.gsub!(/[\t\n]*/, '') }
      breadcrumbs = breadcrumbs.join ' *** '
      breadcrumbs.scan(reg_exp) ? breadcrumbs.scan(reg_exp)[0].first : nil
    end

  end


  # Класс реализует заглушку BaseNavigation из системы создания правил
  # Реализуем все необходимые методы
  class BaseNavigation < Template
    # заглушка на add_todo метод, просто выводит на экран сформированные параметры для тудушки
    # этот метод и вывоит то, что мы хотим получить на выходе
    def add_todo(data)
      p data
    end
  end

end
