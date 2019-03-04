# -*- coding: utf-8 -*-
import scrapy
from scrapy import Spider
from scrapy.http import Request



class KidsSpider(scrapy.Spider):
    name = 'kids'
    allowed_domains = ['kg.sofia.bg']
    start_urls = ['https://kg.sofia.bg/isodz/dz/by-region/all']

    def parse(self, response):
        #print(response.xpath('//table/tr/td/a/@href')[1].extract())
        pages = response.xpath('//table/tr/td/a/@href').extract()
        for page in pages:
 #           if page is not None:
            abs_page = response.urljoin(page)
            yield Request(abs_page,callback = self.parse_kg)
            
    def parse_kg(self, response):
        pages = response.xpath('//a[contains(@href,"waiting")]/@href').extract()
      # if pages:
        for page in pages:
            abs_page = response.urljoin(page)
            yield Request(abs_page,callback = self.parse_waiting)
            
            
    def parse_waiting(self,response):
        group = response.xpath('//strong[contains(text(),"20")]/text()').get()
        rows = response.selector.xpath('//*[contains(text(),"Списък чакащи за")]/following-sibling::table//tr')
        for row in rows[1:]:
            name = row.xpath('td/text()').extract()[0]
            number = row.xpath('td/text()').extract()[1]
            points = row.xpath('td/text()').extract()[2]
            pref = row.xpath('td/text()').extract()[3]
            
            
            yield  {'Group':group,
                    'Name':name,
                    'Number':number,
                    'Points':points,
                    'Preference':pref
                    }
