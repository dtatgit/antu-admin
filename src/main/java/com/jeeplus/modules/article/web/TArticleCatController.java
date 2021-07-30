/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.jeeplus.modules.article.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.config.Global;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.modules.article.entity.TArticleCat;
import com.jeeplus.modules.article.service.TArticleCatService;

/**
 * 文章分类Controller
 * @author ffy
 * @version 2021-06-18
 */
@Controller
@RequestMapping(value = "${adminPath}/article/tArticleCat")
public class TArticleCatController extends BaseController {

	@Autowired
	private TArticleCatService tArticleCatService;
	
	@ModelAttribute
	public TArticleCat get(@RequestParam(required=false) String id) {
		TArticleCat entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = tArticleCatService.get(id);
		}
		if (entity == null){
			entity = new TArticleCat();
		}
		return entity;
	}
	
	/**
	 * 文章分类列表页面
	 */
	@RequiresPermissions("article:tArticleCat:list")
	@RequestMapping(value = {"list", ""})
	public String list(TArticleCat tArticleCat,  HttpServletRequest request, HttpServletResponse response, Model model) {
	
		model.addAttribute("tArticleCat", tArticleCat);
		return "modules/article/tArticleCatList";
	}

	/**
	 * 查看，增加，编辑文章分类表单页面
	 */
	@RequiresPermissions(value={"article:tArticleCat:view","article:tArticleCat:add","article:tArticleCat:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(TArticleCat tArticleCat, Model model) {
		if (tArticleCat.getParent()!=null && StringUtils.isNotBlank(tArticleCat.getParent().getId())){
			tArticleCat.setParent(tArticleCatService.get(tArticleCat.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtils.isBlank(tArticleCat.getId())){
				TArticleCat tArticleCatChild = new TArticleCat();
				tArticleCatChild.setParent(new TArticleCat(tArticleCat.getParent().getId()));
				List<TArticleCat> list = tArticleCatService.findList(tArticleCat); 
				if (list.size() > 0){
					tArticleCat.setSort(list.get(list.size()-1).getSort());
					if (tArticleCat.getSort() != null){
						tArticleCat.setSort(tArticleCat.getSort() + 30);
					}
				}
			}
		}
		if (tArticleCat.getSort() == null){
			tArticleCat.setSort(30);
		}
		model.addAttribute("tArticleCat", tArticleCat);
		return "modules/article/tArticleCatForm";
	}

	/**
	 * 保存文章分类
	 */
	@ResponseBody
	@RequiresPermissions(value={"article:tArticleCat:add","article:tArticleCat:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public AjaxJson save(TArticleCat tArticleCat, Model model) throws Exception{
		AjaxJson j = new AjaxJson();
		/**
		 * 后台hibernate-validation插件校验
		 */
		String errMsg = beanValidator(tArticleCat);
		if (StringUtils.isNotBlank(errMsg)){
			j.setSuccess(false);
			j.setMsg(errMsg);
			return j;
		}

		//新增或编辑表单保存
		tArticleCatService.save(tArticleCat);//保存
		j.setSuccess(true);
		j.put("tArticleCat", tArticleCat);
		j.setMsg("保存文章分类成功");
		return j;
	}
	
	@ResponseBody
	@RequestMapping(value = "getChildren")
	public List<TArticleCat> getChildren(String parentId){
		if("-1".equals(parentId)){//如果是-1，没指定任何父节点，就从根节点开始查找
			parentId = "0";
		}
		return tArticleCatService.getChildren(parentId);
	}
	
	/**
	 * 删除文章分类
	 */
	@ResponseBody
	@RequiresPermissions("article:tArticleCat:del")
	@RequestMapping(value = "delete")
	public AjaxJson delete(TArticleCat tArticleCat) {
		AjaxJson j = new AjaxJson();
		tArticleCatService.delete(tArticleCat);
		j.setSuccess(true);
		j.setMsg("删除文章分类成功");
		return j;
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<TArticleCat> list = tArticleCatService.findList(new TArticleCat());
		for (int i=0; i<list.size(); i++){
			TArticleCat e = list.get(i);
			if (StringUtils.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)){
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("text", e.getName());
				if(StringUtils.isBlank(e.getParentId()) || "0".equals(e.getParentId())){
					map.put("parent", "#");
					Map<String, Object> state = Maps.newHashMap();
					state.put("opened", true);
					map.put("state", state);
				}else{
					map.put("parent", e.getParentId());
				}
				mapList.add(map);
			}
		}
		return mapList;
	}
	
}