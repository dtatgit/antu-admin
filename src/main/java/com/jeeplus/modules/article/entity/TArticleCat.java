/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.jeeplus.modules.article.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;

import com.jeeplus.core.persistence.TreeEntity;

/**
 * 文章分类Entity
 * @author ffy
 * @version 2021-06-18
 */
public class TArticleCat extends TreeEntity<TArticleCat> {
	
	private static final long serialVersionUID = 1L;
	
	
	public TArticleCat() {
		super();
	}

	public TArticleCat(String id){
		super(id);
	}

	public  TArticleCat getParent() {
			return parent;
	}
	
	@Override
	public void setParent(TArticleCat parent) {
		this.parent = parent;
		
	}
	
	public String getParentId() {
		return parent != null && parent.getId() != null ? parent.getId() : "0";
	}
}