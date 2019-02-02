require 'mechanize'

class Parser
  def initialize
    a = Mechanize.new
    @page = a.get('https://icitata.ru/citaty-iz-pesen-rep/')
  end

  def get_wordplay
    @page.css('.td-ss-main-content p:nth-child(n)').map(&:inner_text)
  end
end
