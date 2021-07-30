/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.jeeplus.modules.article.entity;

import com.jeeplus.modules.article.entity.TArticleCat;
import javax.validation.constraints.NotNull;

import com.jeeplus.core.persistence.DataEntity;
import com.jeeplus.common.utils.excel.annotation.ExcelField;

/**
 * 文章管理Entity
 * @author ffy
 * @version 2021-06-18
 */
public class TArticle extends DataEntity<TArticle> {
	
	private static final long serialVersionUID = 1L;
	private TArticleCat cat;		// 分类id
	private String articleTitle;		// 文章标题
	private String coverImg;		// 文章封面图片
	private String articleContent;		// 文章内容

	private String catName; //分类名字 冗余

	public TArticle() {
		super();
	}

	public TArticle(String id){
		super(id);
	}

	@NotNull(message="分类id不能为空")
	@ExcelField(title="分类id", fieldType=TArticleCat.class, value="cat.name", align=2, sort=1)
	public TArticleCat getCat() {
		return cat;
	}

	public void setCat(TArticleCat cat) {
		this.cat = cat;
	}
	
	@ExcelField(title="文章标题", align=2, sort=2)
	public String getArticleTitle() {
		return articleTitle;
	}

	public void setArticleTitle(String articleTitle) {
		this.articleTitle = articleTitle;
	}
	
	@ExcelField(title="文章封面图片", align=2, sort=3)
	public String getCoverImg() {
		return coverImg;
	}

	public void setCoverImg(String coverImg) {
		this.coverImg = coverImg;
	}
	
	@ExcelField(title="文章内容", align=2, sort=4)
	public String getArticleContent() {
		return articleContent;
	}

	public void setArticleContent(String articleContent) {
		this.articleContent = articleContent;
	}

	public String getCatName() {
		return catName;
	}

	public void setCatName(String catName) {
		this.catName = catName;
	}
}