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
  def run(context)
    url = @todo[:url]
    doc = context.doc
    sel = doc.xpath("//select[@aria-label='Page']/option/@value")
    return unless sel.size > 1 && url !~ /Nrpp/

    sel[1..-1].each do |u|
      add_todo(url: "https://ulta.com" + u)
    end
  end
end

url = 'https://www.ulta.com/hair-shampoo-conditioner?N=27ih'
proxy = 'vmdqproxygw.profitero.local:64128'
proxy_pwd = '38_94_183_46_65432:pass'

# созадем контекст
ctx = Scripting::NavigatorContext.new(url, proxy, proxy_pwd)
# создаем экземпляр тестируемого класса
n = Navigator.new(url)
# запускаем метод, который мы дебажим
n.run(ctx)

