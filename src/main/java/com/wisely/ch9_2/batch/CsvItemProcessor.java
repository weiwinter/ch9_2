package com.wisely.ch9_2.batch;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.batch.item.validator.ValidatingItemProcessor;

import com.wisely.ch9_2.domain.Person;

public class CsvItemProcessor extends ValidatingItemProcessor<Person> {

	private Logger logger = LoggerFactory.getLogger(CsvItemProcessor.class);
	
	@Override
	public Person process(Person item) {
		super.process(item);
		logger.info("processor start validating...");
		// 数据处理，比如将中文性别设置为M/F
        if ("男".equals(item.getGender())) {
            item.setGender("M");
        } else {
            item.setGender("F");
        }
        logger.info("processor end validating...");
		return item;
		
	}
}
