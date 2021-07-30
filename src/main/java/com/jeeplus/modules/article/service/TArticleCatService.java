/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.jeeplus.modules.article.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jeeplus.core.service.TreeService;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.modules.article.entity.TArticleCat;
import com.jeeplus.modules.article.mapper.TArticleCatMapper;

/**
 * 文章分类Service
 * @author ffy
 * @version 2021-06-18
 */
@Service
@Transactional(readOnly = true)
public class TArticleCatService extends TreeService<TArticleCatMapper, TArticleCat> {

	public TArticleCat get(String id) {
		return super.get(id);
	}

	public TArticleCat findOneByName(String name){
		return mapper.findOneByName(name);
	}

	public List<TArticleCat> findList(TArticleCat tArticleCat) {
		if (StringUtils.isNotBlank(tArticleCat.getParentIds())){
			tArticleCat.setParentIds(","+tArticleCat.getParentIds()+",");
		}
		return super.findList(tArticleCat);
	}
	
	@Transactional(readOnly = false)
	public void save(TArticleCat tArticleCat) {
		super.save(tArticleCat);
	}
	
	@Transactional(readOnly = false)
	public void delete(TArticleCat tArticleCat) {
		super.delete(tArticleCat);
	}
	
}