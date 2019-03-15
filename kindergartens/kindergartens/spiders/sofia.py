# -*- coding: utf-8 -*-
import scrapy
from scrapy import Spider
from scrapy.http import Request

class Table(scrapy.Item):
    kg = scrapy.Field()
    region = scrapy.Field()
    address = scrapy.Field()
    webpage = scrapy.Field()
    enrolled2018ord = scrapy.Field()
    enrolled2018chron = scrapy.Field()
    enrolled2018sop = scrapy.Field()
    enrolled2018wg = scrapy.Field() 
    enrolled2017ord = scrapy.Field()
    enrolled2017chron = scrapy.Field()
    enrolled2017sop = scrapy.Field()
    enrolled2017wg = scrapy.Field()
    enrolled2016ord = scrapy.Field()
    enrolled2016chron = scrapy.Field()
    enrolled2016sop = scrapy.Field()
    enrolled2016wg = scrapy.Field()
    enrolled2015ord = scrapy.Field()
    enrolled2015chron = scrapy.Field()
    enrolled2015sop = scrapy.Field()
    enrolled2015wg = scrapy.Field() 
    enrolled2014ord = scrapy.Field()
    enrolled2014chron = scrapy.Field()
    enrolled2014sop = scrapy.Field()
    enrolled2014wg = scrapy.Field() 
    enrolled2013ord = scrapy.Field()
    enrolled2013chron = scrapy.Field()
    enrolled2013sop = scrapy.Field()
    enrolled2013wg = scrapy.Field() 
    enrolled2012ord = scrapy.Field()
    enrolled2012chron = scrapy.Field()
    enrolled2012sop = scrapy.Field()
    enrolled2012wg = scrapy.Field()     


class SofiaSpider(scrapy.Spider):
    name = 'sofia'
    allowed_domains = ['kg.sofia.bg']
    start_urls = ['https://kg.sofia.bg/isodz/dz/by-region/all']
    custom_settings = {'FEED_URI': 'enrolled.csv'}

    def parse(self, response):
        #print(response.xpath('//table/tr/td/a/@href')[1].extract())
        pages = response.xpath('//table/tr/td/a/@href').extract()
        for page in pages:
            abs_page = response.urljoin(page)
            article = Table()
            article['webpage'] = abs_page
            yield Request(abs_page, meta={'item':article},callback = self.parse_kg)
            
    def parse_kg(self,response):
        #pass
        article = response.request.meta['item']
        kg = response.xpath('//*[@id="main"]/div[1]/div/text()').get(default = "NA").strip()
        region = response.xpath('//td[contains(text(),"Район")]/following-sibling::td/strong/text()').get(default = "NA")
        address = response.xpath('//td[contains(text(),"Адрес")]/following-sibling::td//text()').get(default = "NA")
 
        enrolled2018ord = response.xpath('//td[contains(text(),"2018")]/following-sibling::td[3]/text()').get(default = "0")
        enrolled2018chron = response.xpath('//td[contains(text(),"2018")]/parent::tr/following-sibling::tr/td[contains(text(),"Хронични")]/following-sibling::td/text()').get(default = "0")
        enrolled2018sop = response.xpath('//td[contains(text(),"2018")]/parent::tr/following-sibling::tr/td[contains(text(),"СОП")]/following-sibling::td/text()').get(default = "0")
        enrolled2018wg = response.xpath('//td[contains(text(),"2018")]/parent::tr/following-sibling::tr/td[contains(text(),"Работна")]/following-sibling::td/text()').get(default = "0")
                    
        enrolled2017ord = response.xpath('//td[contains(text(),"2017")]/following-sibling::td[3]/text()').get(default = "0")
        enrolled2017chron = response.xpath('//td[contains(text(),"2017")]/parent::tr/following-sibling::tr/td[contains(text(),"Хронични")]/following-sibling::td/text()').get(default = "0")
        enrolled2017sop = response.xpath('//td[contains(text(),"2017")]/parent::tr/following-sibling::tr/td[contains(text(),"СОП")]/following-sibling::td/text()').get(default = "0")
        enrolled2017wg = response.xpath('//td[contains(text(),"2017")]/parent::tr/following-sibling::tr/td[contains(text(),"Работна")]/following-sibling::td/text()').get(default = "0")

        enrolled2016ord = response.xpath('//td[contains(text(),"2016")]/following-sibling::td[3]/text()').get(default = "0")
        enrolled2016chron = response.xpath('//td[contains(text(),"2016")]/parent::tr/following-sibling::tr/td[contains(text(),"Хронични")]/following-sibling::td/text()').get(default = "0")
        enrolled2016sop = response.xpath('//td[contains(text(),"2016")]/parent::tr/following-sibling::tr/td[contains(text(),"СОП")]/following-sibling::td/text()').get(default = "0")
        enrolled2016wg = response.xpath('//td[contains(text(),"2016")]/parent::tr/following-sibling::tr/td[contains(text(),"Работна")]/following-sibling::td/text()').get(default = "0")

        enrolled2015ord = response.xpath('//td[contains(text(),"2015")]/following-sibling::td[3]/text()').get(default = "0")
        enrolled2015chron = response.xpath('//td[contains(text(),"2015")]/parent::tr/following-sibling::tr/td[contains(text(),"Хронични")]/following-sibling::td/text()').get(default = "0")
        enrolled2015sop = response.xpath('//td[contains(text(),"2015")]/parent::tr/following-sibling::tr/td[contains(text(),"СОП")]/following-sibling::td/text()').get(default = "0")
        enrolled2015wg = response.xpath('//td[contains(text(),"2015")]/parent::tr/following-sibling::tr/td[contains(text(),"Работна")]/following-sibling::td/text()').get(default = "0")
        
        enrolled2014ord = response.xpath('//td[contains(text(),"2014")]/following-sibling::td[3]/text()').get(default = "0")
        enrolled2014chron = response.xpath('//td[contains(text(),"2014")]/parent::tr/following-sibling::tr/td[contains(text(),"Хронични")]/following-sibling::td/text()').get(default = "0")
        enrolled2014sop = response.xpath('//td[contains(text(),"2014")]/parent::tr/following-sibling::tr/td[contains(text(),"СОП")]/following-sibling::td/text()').get(default = "0")
        enrolled2014wg = response.xpath('//td[contains(text(),"2014")]/parent::tr/following-sibling::tr/td[contains(text(),"Работна")]/following-sibling::td/text()').get(default = "0")

        enrolled2013ord = response.xpath('//td[contains(text(),"2013")]/following-sibling::td[3]/text()').get(default = "0")
        enrolled2013chron = response.xpath('//td[contains(text(),"2013")]/parent::tr/following-sibling::tr/td[contains(text(),"Хронични")]/following-sibling::td/text()').get(default = "0")
        enrolled2013sop = response.xpath('//td[contains(text(),"2013")]/parent::tr/following-sibling::tr/td[contains(text(),"СОП")]/following-sibling::td/text()').get(default = "0")
        enrolled2013wg = response.xpath('//td[contains(text(),"2013")]/parent::tr/following-sibling::tr/td[contains(text(),"Работна")]/following-sibling::td/text()').get(default = "0")
    
        enrolled2012ord = response.xpath('//td[contains(text(),"2012")]/following-sibling::td[3]/text()').get(default = "0")
        enrolled2012chron = response.xpath('//td[contains(text(),"2012")]/parent::tr/following-sibling::tr/td[contains(text(),"Хронични")]/following-sibling::td/text()').get(default = "0")
        enrolled2012sop = response.xpath('//td[contains(text(),"2012")]/parent::tr/following-sibling::tr/td[contains(text(),"СОП")]/following-sibling::td/text()').get(default = "0")
        enrolled2012wg = response.xpath('//td[contains(text(),"2012")]/parent::tr/following-sibling::tr/td[contains(text(),"Работна")]/following-sibling::td/text()').get(default = "0")
          
         

        article['kg'] = kg
        article['region'] = region
        article['address'] = address  
        article['enrolled2018ord'] = enrolled2018ord 
        article['enrolled2018chron'] = enrolled2018chron 
        article['enrolled2018sop'] = enrolled2018sop 
        article['enrolled2018wg'] = enrolled2018wg 
        article['enrolled2017ord'] = enrolled2017ord 
        article['enrolled2017chron'] = enrolled2017chron 
        article['enrolled2017sop'] = enrolled2017sop 
        article['enrolled2017wg'] = enrolled2017wg 
        article['enrolled2016ord'] = enrolled2016ord 
        article['enrolled2016chron'] = enrolled2016chron 
        article['enrolled2016sop'] = enrolled2016sop 
        article['enrolled2016wg'] = enrolled2016wg      
        article['enrolled2015ord'] = enrolled2015ord 
        article['enrolled2015chron'] = enrolled2015chron 
        article['enrolled2015sop'] = enrolled2015sop 
        article['enrolled2015wg'] = enrolled2015wg      
        article['enrolled2014ord'] = enrolled2014ord 
        article['enrolled2014chron'] = enrolled2014chron 
        article['enrolled2014sop'] = enrolled2014sop 
        article['enrolled2014wg'] = enrolled2014wg  
        article['enrolled2013ord'] = enrolled2013ord 
        article['enrolled2013chron'] = enrolled2013chron 
        article['enrolled2013sop'] = enrolled2013sop 
        article['enrolled2013wg'] = enrolled2013wg  
        article['enrolled2012ord'] = enrolled2012ord 
        article['enrolled2012chron'] = enrolled2012chron 
        article['enrolled2012sop'] = enrolled2012sop 
        article['enrolled2012wg'] = enrolled2012wg  

        
        yield article
        