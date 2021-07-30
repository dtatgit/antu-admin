/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.jeeplus.modules.article.mapper;

import com.jeeplus.core.persistence.TreeMapper;
import com.jeeplus.core.persistence.annotation.MyBatisMapper;
import com.jeeplus.modules.article.entity.TArticleCat;
import org.apache.ibatis.annotations.Param;

/**
 * 文章分类MAPPER接口
 * @author ffy
 * @version 2021-06-18
 */
@MyBatisMapper
public interface TArticleCatMapper extends TreeMapper<TArticleCat> {

    TArticleCat findOneByName(@Param(value="name")String name);
}