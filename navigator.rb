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
  def run(context)
    url = @todo[:url]
    doc = context[:doc]

    # достаем номер последней страницы из меню пагинации
    # беру предпоследний li (в последнем стрелка)
    last_page = doc.xpath("//div[@class='bx_pagination_page']//li")[-2]

    # если на странице нет пагинации (last_page = nil), или мы на странице у которой уже есть параметр page
    # выходим не добавляя тудушек
    return unless last_page && url !~ /PAGEN/

    # добавляем в туду страницы (2..last_page)
    (2..last_page.text.to_i).each do |time|
      add_todo(url: "#{url}?PAGEN_1=#{time}&SIZEN_1=20")
    end
  end
end

# Непосредственно тестируем наш класс
# создадим экземпляр Navigator, передав в конструктор url искомой страницы
# затем вызовем метод run, передавая в него контекст из этого же экземпляра
# контекст можно было и не передавать, это сделано лишь для того, что бы не нарушить внейшний вид нужного нам кода
n = Navigator.new 'https://garfield.by/catalog/dogs/vitaminy-i-dobavki.html'
n.run n.context
