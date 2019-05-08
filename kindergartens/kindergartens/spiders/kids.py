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
    name = scrapy.Field()
    id = scrapy.Field()
    points = scrapy.Field()
    preference = scrapy.Field()
    
class KidsSpider(scrapy.Spider):
    name = 'kids'
    allowed_domains = ['kg.sofia.bg']
    start_urls = ['https://kg.sofia.bg/isodz/dz/by-region/all']
    custom_settings = {'FEED_URI': 'waiting.csv'}

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
        pages = response.xpath('//div[contains(text(),"с прием от септември")]/following-sibling::div//td[contains(text(),"родени")]/following-sibling::td[1]//a[contains(@href,"waiting")]/@href').extract()
        #pages = response.xpath('//td[contains(text(),"от септември")]/following-sibling::td[1]//a[contains(@href,"waiting")]/@href').extract()# pages = response.xpath('//div[contains(text(),"с прием от септември")]/following-sibling::div//td[contains(text(),"родени")]/following-sibling::td[1]//a[contains(@href,"waiting")]/@href').extract()
        #if pages:
        for page in pages:
            if page is not None:
                abs_page = response.urljoin(page)
                second['kg'] = kg
                second['region'] = region
                second['webpage'] = first['webpage']
                #yield second
                yield Request(abs_page, meta={'item':second}, callback = self.parse_waiting)
            
    def parse_waiting(self,response):
        second = response.request.meta['item']
        born = response.xpath('//strong[contains(text(),"родени")]/text()').get().split()[-2]
        group = response.selector.xpath('//table/preceding-sibling::*[1]')
        third = Table()
        for g in group:
            tail = g.xpath('text()').get().split()[3].capitalize()
            places = g.xpath('text()').get().split()[-2]
            rows = g.xpath('following-sibling::*[1]//tr')
            for row in rows[1:]:
                name = row.xpath('td/text()').extract()[0].split()[1]
                number = row.xpath('td/text()').extract()[1]
                points = row.xpath('td/text()').extract()[2]
                pref = row.xpath('td/text()').extract()[3]
                    
                third['kg'] = second['kg']
                third['region'] = second['region']
                third['webpage'] = second['webpage']
                third['born'] = born
                third['tail'] = tail
                third['places'] = places
                third['name'] = name
                third['id'] = number
                third['points'] = points
                third['preference'] = pref
                
                yield third

            
            
   
