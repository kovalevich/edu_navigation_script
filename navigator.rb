# frozen_string_literal: true

require './scripting.rb'

# реализация класса навигации (код, который мы вставляем в форму правила)
# этот код, если он работает, можно вставлять в форму добавления скрипта на странице настройки правила
# Документация https://space.profitero.com/confluence/display/DQ/Navigation+script
class Navigator1 < Scripting::BaseNavigation
  def run(context)
    categories = %w[catalog/dogs/vitaminy-i-dobavki.html0
                    catalog/dogs/konservyi-dlya-sobak.html
                    catalog/akvariumistika/zhivye-obitateli-/rybki.html]

    # генерим тудухи для 3-х заданных категорий
    categories.each { |cat| add_todo url: 'https://garfield.by/' + cat }
  end
end

class Navigator < Scripting::BaseNavigation

  PRODUCTS_ON_PAGE = 96
  CUSTOM_PRODUCTS_ON_PAGE = 1000
  def run(context)
    url = @todo[:url]
    doc = context[:doc]

    products_count = doc.xpath("//span[@class='search-res-number']").text.to_f
    return unless products_count > PRODUCTS_ON_PAGE && url !~ /Nrpp/

    # делаем вторую страницу продуктов от 96 до products_count
    count_pages = ((products_count - PRODUCTS_ON_PAGE) / CUSTOM_PRODUCTS_ON_PAGE).ceil
    (0...count_pages).each do |p|
      add_todo(url: "#{url}&No=#{PRODUCTS_ON_PAGE + (CUSTOM_PRODUCTS_ON_PAGE * p)}&Nrpp=#{CUSTOM_PRODUCTS_ON_PAGE}")
    end
  end
end

# Непосредственно тестируем наш класс
# создадим экземпляр Navigator, передав в конструктор url искомой страницы
# затем вызовем метод run, передавая в него контекст из этого же экземпляра
# контекст можно было и не передавать, это сделано лишь для того, что бы не нарушить внейшний вид нужного нам кода
n = Navigator.new('https://www.ulta.com/hair-shampoo-conditioner?N=27ih', 'vmdqproxygw.profitero.local:64128', '38_94_183_46_65432:pass')
n.run n.context
