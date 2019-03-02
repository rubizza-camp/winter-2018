require 'mechanize'

class Parser
  def initialize
    a = Mechanize.new
    @page = a.get('https://icitata.ru/citaty-iz-pesen-rep/')
  end

  def getwordplay
    @page.css('.td-ss-main-content p:nth-child(n)').map{|w| w.inner_text}
  end
end
