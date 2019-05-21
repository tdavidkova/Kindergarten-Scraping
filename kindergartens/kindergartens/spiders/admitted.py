# -*- coding: utf-8 -*-
import scrapy
from scrapy import Spider
from scrapy.http import Request

class Table(scrapy.Item):
    kg = scrapy.Field()
    region = scrapy.Field()
    born = scrapy.Field()
    name = scrapy.Field()
    id = scrapy.Field()
    points = scrapy.Field()
    webpage = scrapy.Field()
    
class AdmittedSpider(scrapy.Spider):
    name = 'admitted'
    allowed_domains = ['kg.sofia.bg']
    start_urls = ['https://kg.sofia.bg/isodz/dz/by-region/all']
    custom_settings = {'FEED_URI': 'admitted.csv'}

    def parse(self, response):
        pages = response.xpath('//table/tr/td/a/@href').extract()
        for page in pages:
            abs_page = response.urljoin(page.split(";",1)[0])
            first = Table()
            first['webpage'] = abs_page
            #yield first
            yield Request(abs_page, meta={'item':first}, callback = self.parse_kg)
            
    def parse_kg(self, response):
        first = response.request.meta['item']
        kg = response.xpath('//*[@id="main"]/div[1]/div/text()').get(default = "NA").strip()
        region = response.xpath('//td[contains(text(),"Район")]/following-sibling::td/strong/text()').get(default = "NA")
        #address = response.xpath('//td[contains(text(),"Адрес")]/following-sibling::td//text()').get(default = "NA")
        second = Table()
        pages = response.xpath('//div[contains(text(),"Групи с прием от септември")]/following-sibling::div//b[contains(text(),"КЛАСИРАНИ на 11.05.2019г.")]/ancestor::a/@href').extract()
        #if pages:
        for page in pages:
            if page is not None:
                abs_page = response.urljoin(page)
                second['kg'] = kg
                second['region'] = region
                second['webpage'] = first['webpage']
                # yield second
                yield Request(abs_page, meta={'item':second}, callback = self.parse_admitted)
            
    def parse_admitted(self,response):
        second = response.request.meta['item']
        born = response.xpath('//strong[contains(text(),"Набор")]/text()').get().split()[-1]
        rows = response.selector.xpath('//table//tr/td[contains(text(),"")]/ancestor::tr')
        for row in rows:
            if len(row.xpath('td/text()')) >0:
                name = row.xpath('td/text()').extract()[1]
                number = row.xpath('td/text()').extract()[2]
                points = row.xpath('td/text()').extract()[3]
                third = Table()        
                third['kg'] = second['kg']
                third['region'] = second['region']
                third['born'] = born
                third['name'] = name
                third['id'] = number
                third['points'] = points
            
                yield third

        
        
   
