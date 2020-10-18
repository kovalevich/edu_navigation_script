# frozen_string_literal: true

require './scripting.rb'

# реализация класса навигации (код, который мы вставляем в форму правила)
# этот код, если он работает, можно вставлять в форму добавления скрипта на странице настройки правила
class Navigator < Scripting::BaseNavigation
  def run(context)
    url = @todo[:url]
    doc = context[:doc]

    pages = %w[irons comics toothbrushes]
    pages.each { |u| add_todo(url: "https://oz.by/#{u}/") }

    #add_todo({:url => <url>, :headers => {} , :post_body => [lines], :has_next => true|false, :user_data => []})
  end
end

# Непосредственно тестируем наш класс
# создадим экземпляр Navigator, передав в конструктор url искомой страницы
# затем вызовем метод run, передавая в него контекст из этого же экземпляра
# контекст можно было и не передавать, это сделано лишь для того, что бы не нарушить внейшний вид нужного нам кода
n = Navigator.new 'https://oz.by/'
n.run n.context
