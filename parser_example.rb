# frozen_string_literal: true

require './scripting.rb'
require 'json'

module Scripting
  # изменим контекст для шопа garfild. ВНИМАНИЕ!!! тут пишем код, который касается только гарфилда
  # если пишете методы абстрактные, выносите их в файл scripting.rb
  # Тут иммитируем работу вашего настроенного экстрактора, вытаскиваем все поля, которые вытаскивает экстрактор
  # записываем в хэш context.base_product
  class CustomParser
    def context
      super_ctx = super
      ctx = Scripting::ParserContext.new(super_ctx[:doc], super_ctx[:body])
      doc = ctx.doc

      # эту чать кода приводим в соответствии с вашим экстратором
      # пока доступны метод prop для простых полей, не требующих дополнительных преобразований и метод breadcrumb
      # вы можете создать (и это будет хорошо) методы для обработки instore, price и т.д
      # это делается в абстрактном классе CustomParser в файле scripting
      base_product = {
          BREADCRUMB => breadcrumbs(doc, "//div[@class='bx-breadcrumb']", /^.*?\*{3}(.*)\*{3}.*$/),
          NAME => prop(doc, "//h1[contains(@class, 'card__title')]"),
          PRICE => prop(doc, "//div[@class='product-card__price-main']/@data-num-price"),
          REGULAR_PRICE => prop(doc, "//p[contains(@class, '__price-old')]"),
          SKU => prop(doc, "//span[@class='item_art_number']"),
          BRAND => prop(doc, "//div[contains(@class, '__producer-img')]//img/@alt"),
          KEY => nil,
          STOCK => nil
      }
      ctx.base_product = base_product
      ctx
    end
  end
end

# непосредственно код, который всавляем в админку. если для ctx или CustomParser не хватает какого-то функционала,
# который есть на продакшене, его можно допилить в scripting.rb
class EducationGarfild < Scripting::CustomParser

  def parse(ctx)

    base = ctx.base_product
    doc = ctx.doc

    # тут логика обрабоки страницы
    # проверяю есть ли base_product
    # добполняем данные base_product, которые не собрал экстратор
    # проверяем есть ли мультипродукты, если есть парсим их методом parse_offers
    # возвращаем true, если распарсили мультипродукты
  end
end

# Непосредственно тестируем наш класс
# создадим экземпляр EducationGarfild, передав в конструктор url искомой страницы
# затем вызовем метод parse, передавая в него контекст из этого же экземпляра
# контекст можно было и не передавать, это сделано лишь для того, что бы не нарушить внейшний вид нужного нам кода
n = EducationGarfild.new 'https://garfield.by/catalog/cats/napolniteli/komkuyushchiysya/cats-best-koplus10.html' # multiproduct
#n = EducationGarfild.new 'https://garfield.by/catalog/dogs/igrushki/dlya-dressury-i-igr-s-khozyainom/igrushka-dlya-trenirovki-sobak-puller-micro.html' # singleproduct
n.parse n.context
