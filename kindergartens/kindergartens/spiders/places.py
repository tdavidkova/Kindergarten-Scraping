# -*- coding: utf-8 -*-
import scrapy
from scrapy import Spider
from scrapy.http import Request

class Table(scrapy.Item):
    kg = scrapy.Field()
    region = scrapy.Field()
    webpage = scrapy.Field()
    born = scrapy.Field()
    places = scrapy.Field()
    tail = scrapy.Field()

    
class PlacesSpider(scrapy.Spider):
    name = 'places'
    allowed_domains = ['kg.sofia.bg']
    start_urls = ['https://kg.sofia.bg/isodz/dz/by-region/all']
    custom_settings = {'FEED_URI': 'places.csv'}

    def parse(self, response):
        pages = response.xpath('//table/tr/td/a/@href').extract()
        for page in pages:
 #           if page is not None:
            abs_page = response.urljoin(page.split(";",1)[0])
            first = Table()
            first['webpage'] = abs_page
            yield Request(abs_page, meta={'item':first}, callback = self.parse_kg)
            
    def parse_kg(self, response):
        first = response.request.meta['item']
        kg = response.xpath('//*[@id="main"]/div[1]/div/text()').get(default = "NA").strip()
        region = response.xpath('//td[contains(text(),"Район")]/following-sibling::td/strong/text()').get(default = "NA")
        #address = response.xpath('//td[contains(text(),"Адрес")]/following-sibling::td//text()').get(default = "NA")
        second = Table()
        pages = response.xpath('//div[contains(text(),"с прием от септември")]/following-sibling::div//td[contains(text(),"родени")]/following-sibling::td[1]//a[contains(@href,"waiting")]/@href').extract()
      # if pages:
        for page in pages:
            abs_page = response.urljoin(page)
            second['kg'] = kg
            second['region'] = region
            second['webpage'] = first['webpage']
            
            yield Request(abs_page, meta={'item':second}, callback = self.parse_waiting)
            
    def parse_waiting(self,response):
        second = response.request.meta['item']
        born = response.xpath('//strong[contains(text(),"родени")]/text()').get().split()[-2]
        group = response.selector.xpath('//div[contains(text(),"Списък")]')
        third = Table()
        for g in group:
            tail = g.xpath('text()').get().split()[3].capitalize()
            places = g.xpath('text()').get().split()[-2]
            
                    
            third['kg'] = second['kg']
            third['region'] = second['region']
            third['webpage'] = second['webpage']
            third['born'] = born
            third['tail'] = tail
            third['places'] = places
                
                
            yield third

            
            
   
