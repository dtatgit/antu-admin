package com.jeeplus.modules.api;

import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.modules.article.entity.TArticle;
import com.jeeplus.modules.article.entity.TArticleCat;
import com.jeeplus.modules.article.service.TArticleService;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value = "${adminPath}/api/articles")
public class ArticlesControllerApi {


    @Autowired
    private TArticleService articleService;

    @RequestMapping(value = "/listOfPageSize")
    public AjaxJson listOfNums(@RequestParam("pageSize")Integer pageSize,
                               @RequestParam(name = "catName",required = false)String catName,Model model) throws Exception{
        AjaxJson j = new AjaxJson();


        TArticle tArticle = new TArticle();

        if(StringUtils.isNotBlank(catName)){

            tArticle.setCatName(catName);
        }

        Page<TArticle> page = articleService.findPageNoFilter(new Page<>(1,pageSize), tArticle);
        List<TArticle> list = page.getList();
        if(list!=null&&!list.isEmpty()){
            list.forEach(item->{
                String content = StringEscapeUtils.unescapeHtml4(item.getArticleContent());
                item.setArticleContent(content);
                item.setArticleTitle(StringEscapeUtils.unescapeHtml4(item.getArticleTitle()));
                item.setRemarks(StringEscapeUtils.unescapeHtml4(item.getRemarks()));
            });
        }

        j.setData(getBootstrapData(page));

        return j;
    }


    @RequestMapping(value = "/list")
    public AjaxJson list(TArticle articles,
                         @RequestParam(name = "catId",required = false)String catId,
                         @RequestParam(name = "catName",required = false)String catName,
                         HttpServletRequest request, HttpServletResponse response, Model model) {

        AjaxJson j = new AjaxJson();

        if(StringUtils.isNotBlank(catId)){
            articles.setCat(new TArticleCat(catId));
        }

        if(StringUtils.isNotBlank(catName)){

            articles.setCatName(catName);
        }

        Page<TArticle> page = articleService.findPageNoFilter(new Page<TArticle>(request, response), articles);
        List<TArticle> list = page.getList();
        if(list!=null&&!list.isEmpty()){
            list.forEach(item->{
                String content = StringEscapeUtils.unescapeHtml4(item.getArticleContent());
                item.setArticleContent(content);
                item.setArticleTitle(StringEscapeUtils.unescapeHtml4(item.getArticleTitle()));
                item.setRemarks(StringEscapeUtils.unescapeHtml4(item.getRemarks()));
            });
        }
        j.setData(getBootstrapData(page));
        return j;
    }


    @RequestMapping(value = "/details")
    public AjaxJson informationDetails(@RequestParam("id") String id, HttpServletRequest request, HttpServletResponse response) {

        AjaxJson j = new AjaxJson();

        TArticle articles = articleService.get(id);

        if(articles!=null){
            String content = StringEscapeUtils.unescapeHtml4(articles.getArticleContent());
            articles.setArticleContent(content);
            articles.setArticleTitle(StringEscapeUtils.unescapeHtml4(articles.getArticleTitle()));
            articles.setRemarks(StringEscapeUtils.unescapeHtml4(articles.getRemarks()));
        }else {
            j.setSuccess(false);
            j.setMsg("无数据");
            return j;
        }

        j.setData(articles);

        return j;
    }


    /**
     * 获取bootstrap data分页数据
     * @param page
     * @return map对象
     */
    public <T> Map<String, Object> getBootstrapData(Page page){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", page.getList());
        map.put("total", page.getCount());
        return map;
    }
}
