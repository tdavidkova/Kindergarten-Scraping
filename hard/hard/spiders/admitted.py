# -*- coding: utf-8 -*-
import scrapy
from scrapy import Spider
from scrapy.http import Request

class Table(scrapy.Item):
    kg = scrapy.Field()
    enrolled2017 = scrapy.Field()
    enrolled2016 = scrapy.Field()
    enrolled2015 = scrapy.Field()
    region = scrapy.Field()
    

class AdmittedSpider(scrapy.Spider):
    name = 'admitted'
    allowed_domains = ['kg.sofia.bg']
    start_urls = ['https://kg.sofia.bg/isodz/dz/by-region/all']

    def parse(self, response):
        #print(response.xpath('//table/tr/td/a/@href')[1].extract())
        pages = response.xpath('//table/tr/td/a/@href').extract()
        for page in pages:
            abs_page = response.urljoin(page)
            yield Request(abs_page,callback = self.parse_kg)
            
    def parse_kg(self,response):
        #pass
        kg = response.xpath('//*[@id="main"]/div[1]/div/text()').extract_first(default = "na").strip()
        enrolled2017 = response.xpath('//td[contains(text(),"2017")]/following-sibling::td[3]/text()').extract_first(default = "na")
        enrolled2016 = response.xpath('//td[contains(text(),"2016")]/following-sibling::td[3]/text()').extract_first(default = "na")
        enrolled2015 = response.xpath('//td[contains(text(),"2015")]/following-sibling::td[3]/text()').extract_first(default = "na")
        region = response.xpath('//td[contains(text(),"Район")]/following-sibling::td/strong/text()').extract_first(default = "na")
        
         

        article = Table()
        article['kg'] = kg
        article['enrolled2017'] = enrolled2017 
        article['enrolled2016'] = enrolled2016 
        article['enrolled2015'] = enrolled2015 
        article['region'] = region
        
        yield article
        