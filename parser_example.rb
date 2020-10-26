# frozen_string_literal: true

require './scripting.rb'
require 'json'

# ВНИМАНИЕ!!! если неоторые данные в шопе получаете через экстактор, необходимо их предварительно извлечь
# для корректного дебагинга. Это можно сделать дописав класс Scripting::ParserContext прямо в этом файле
# переопределив метод extractor_emulate например:
class Scripting::ParserContext
  def extractor_emulate
    # метод будет доставить какие-то данные и заполнять @base_product
    # как это  и делает экстратор
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

url = 'https://www.ulta.com/hydrate-conditioner?productId=xlsImpprod3410045'
proxy = 'vmdqproxygw.profitero.local:64128'
proxy_pwd = '38_94_183_46_65432:pass'

# созадем контекст
ctx = Scripting::ParserContext.new(url, proxy, proxy_pwd)
# создаем экземпляр тестируемого класса
n = EducationUlta.new(url)
# запускаем метод, который мы дебажим
n.parse(ctx)
