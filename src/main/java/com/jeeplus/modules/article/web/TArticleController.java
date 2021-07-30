/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.jeeplus.modules.article.web;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.collect.Lists;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.config.Global;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.core.web.BaseController;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.modules.article.entity.TArticle;
import com.jeeplus.modules.article.service.TArticleService;

/**
 * 文章管理Controller
 * @author ffy
 * @version 2021-06-18
 */
@Controller
@RequestMapping(value = "${adminPath}/article/tArticle")
public class TArticleController extends BaseController {

	@Autowired
	private TArticleService tArticleService;
	
	@ModelAttribute
	public TArticle get(@RequestParam(required=false) String id) {
		TArticle entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = tArticleService.get(id);
		}
		if (entity == null){
			entity = new TArticle();
		}
		return entity;
	}
	
	/**
	 * 文章列表页面
	 */
	@RequiresPermissions("article:tArticle:list")
	@RequestMapping(value = {"list", ""})
	public String list(TArticle tArticle, Model model) {
		model.addAttribute("tArticle", tArticle);
		String imgUrl = Global.getConfig("images.weburl");
		model.addAttribute("imgUrl",imgUrl);
		return "modules/article/tArticleList";
	}
	
		/**
	 * 文章列表数据
	 */
	@ResponseBody
	@RequiresPermissions("article:tArticle:list")
	@RequestMapping(value = "data")
	public Map<String, Object> data(TArticle tArticle, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<TArticle> page = tArticleService.findPage(new Page<TArticle>(request, response), tArticle); 
		return getBootstrapData(page);
	}

	/**
	 * 查看，增加，编辑文章表单页面
	 */
	@RequiresPermissions(value={"article:tArticle:view","article:tArticle:add","article:tArticle:edit"},logical=Logical.OR)
	@RequestMapping(value = "form/{mode}")
	public String form(@PathVariable String mode, TArticle tArticle, Model model) {
		model.addAttribute("tArticle", tArticle);
		model.addAttribute("mode", mode);
		return "modules/article/tArticleForm";
	}

	/**
	 * 保存文章
	 */
	@ResponseBody
	@RequiresPermissions(value={"article:tArticle:add","article:tArticle:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public AjaxJson save(TArticle tArticle, Model model) throws Exception{
		AjaxJson j = new AjaxJson();
		/**
		 * 后台hibernate-validation插件校验
		 */
		String errMsg = beanValidator(tArticle);
		if (StringUtils.isNotBlank(errMsg)){
			j.setSuccess(false);
			j.setMsg(errMsg);
			return j;
		}
		//新增或编辑表单保存
		tArticleService.save(tArticle);//保存
		j.setSuccess(true);
		j.setMsg("保存文章成功");
		return j;
	}
	
	/**
	 * 删除文章
	 */
	@ResponseBody
	@RequiresPermissions("article:tArticle:del")
	@RequestMapping(value = "delete")
	public AjaxJson delete(TArticle tArticle) {
		AjaxJson j = new AjaxJson();
		tArticleService.delete(tArticle);
		j.setMsg("删除文章成功");
		return j;
	}
	
	/**
	 * 批量删除文章
	 */
	@ResponseBody
	@RequiresPermissions("article:tArticle:del")
	@RequestMapping(value = "deleteAll")
	public AjaxJson deleteAll(String ids) {
		AjaxJson j = new AjaxJson();
		String idArray[] =ids.split(",");
		for(String id : idArray){
			tArticleService.delete(tArticleService.get(id));
		}
		j.setMsg("删除文章成功");
		return j;
	}
	
	/**
	 * 导出excel文件
	 */
	@ResponseBody
	@RequiresPermissions("article:tArticle:export")
    @RequestMapping(value = "export")
    public AjaxJson exportFile(TArticle tArticle, HttpServletRequest request, HttpServletResponse response) {
		AjaxJson j = new AjaxJson();
		try {
            String fileName = "文章"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<TArticle> page = tArticleService.findPage(new Page<TArticle>(request, response, -1), tArticle);
    		new ExportExcel("文章", TArticle.class).setDataList(page.getList()).write(response, fileName).dispose();
    		j.setSuccess(true);
    		j.setMsg("导出成功！");
    		return j;
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg("导出文章记录失败！失败信息："+e.getMessage());
		}
			return j;
    }

	/**
	 * 导入Excel数据

	 */
	@ResponseBody
	@RequiresPermissions("article:tArticle:import")
    @RequestMapping(value = "import")
   	public AjaxJson importFile(@RequestParam("file")MultipartFile file, HttpServletResponse response, HttpServletRequest request) {
		AjaxJson j = new AjaxJson();
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<TArticle> list = ei.getDataList(TArticle.class);
			for (TArticle tArticle : list){
				try{
					tArticleService.save(tArticle);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条文章记录。");
			}
			j.setMsg( "已成功导入 "+successNum+" 条文章记录"+failureMsg);
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg("导入文章失败！失败信息："+e.getMessage());
		}
		return j;
    }
	
	/**
	 * 下载导入文章数据模板
	 */
	@ResponseBody
	@RequiresPermissions("article:tArticle:import")
    @RequestMapping(value = "import/template")
     public AjaxJson importFileTemplate(HttpServletResponse response) {
		AjaxJson j = new AjaxJson();
		try {
            String fileName = "文章数据导入模板.xlsx";
    		List<TArticle> list = Lists.newArrayList(); 
    		new ExportExcel("文章数据", TArticle.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg( "导入模板下载失败！失败信息："+e.getMessage());
		}
		return j;
    }
}