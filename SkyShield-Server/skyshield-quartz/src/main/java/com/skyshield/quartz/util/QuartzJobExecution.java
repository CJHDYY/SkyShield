package com.skyshield.quartz.util;

import org.quartz.JobExecutionContext;
import com.skyshield.quartz.domain.SysJob;

/**
 * 定时任务处理（允许并发执行）
 * 
 * @author skyshield
 *
 */
public class QuartzJobExecution extends AbstractQuartzJob
{
    @Override
    protected void doExecute(JobExecutionContext context, SysJob sysJob) throws Exception
    {
        JobInvokeUtil.invokeMethod(sysJob);
    }
}
