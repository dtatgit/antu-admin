/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.jeeplus.modules.article.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.service.CrudService;
import com.jeeplus.modules.article.entity.TArticle;
import com.jeeplus.modules.article.mapper.TArticleMapper;

/**
 * 文章管理Service
 * @author ffy
 * @version 2021-06-18
 */
@Service
@Transactional(readOnly = true)
public class TArticleService extends CrudService<TArticleMapper, TArticle> {

	public TArticle get(String id) {
		return super.get(id);
	}
	
	public List<TArticle> findList(TArticle tArticle) {
		return super.findList(tArticle);
	}
	
	public Page<TArticle> findPage(Page<TArticle> page, TArticle tArticle) {
		return super.findPage(page, tArticle);
	}

	/**
	 * 自定义，去掉过滤的分页
	 * @param page 分页对象
	 * @param tArticle
	 * @return
	 */
	public Page<TArticle> findPageNoFilter(Page<TArticle> page, TArticle tArticle) {
		return super.findPageNoFilter(page, tArticle);
	}
	
	@Transactional(readOnly = false)
	public void save(TArticle tArticle) {
		super.save(tArticle);
	}
	
	@Transactional(readOnly = false)
	public void delete(TArticle tArticle) {
		super.delete(tArticle);
	}
	
}