package com.jeeplus.modules.api;

import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.core.persistence.Page;
import com.jeeplus.modules.article.entity.TArticle;
import com.jeeplus.modules.article.entity.TArticleCat;
import com.jeeplus.modules.article.service.TArticleCatService;
import com.jeeplus.modules.article.service.TArticleService;
import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value = "${adminPath}/api/articleCat")
public class ArticleCatControllerApi {


    @Autowired
    private TArticleCatService catService;

    @RequestMapping(value = "/findOneByName")
    public AjaxJson findOneByName(@RequestParam("name")String name, Model model) throws Exception{
        AjaxJson j = new AjaxJson();

        TArticleCat oneByName = catService.findOneByName(name);

        j.setData(oneByName);

        return j;
    }
}
