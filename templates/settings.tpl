<script>
	$(function() {ldelim}
		$('#articleMetricsSettingsForm').pkpHandler('$.pkp.controllers.form.AjaxFormHandler');
	{rdelim});
</script>

<form class="pkp_form" id="articleMetricsSettingsForm" method="post" action="{url router=$smarty.const.ROUTE_COMPONENT op="manage" category="generic" plugin=$pluginName verb="settings" save=true}">
	{csrf}
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="articleMetricsSettingsFormNotification"}

	{fbvFormArea id="articleMetricsSettings"}
		{fbvFormSection list=true}
			{fbvElement type="checkbox" id="displayAbstractViews" value="1" checked=$displayAbstractViews label="plugins.generic.articleMetrics.displayAbstractViews"}
			{fbvElement type="checkbox" id="displayDownloads" value="1" checked=$displayDownloads label="plugins.generic.articleMetrics.displayDownloads"}
			{fbvElement type="checkbox" id="displayDoi" value="1" checked=$displayDoi label="plugins.generic.articleMetrics.displayDoi"}
			{fbvElement type="checkbox" id="displayAuthorAffiliation" value="1" checked=$displayAuthorAffiliation label="plugins.generic.articleMetrics.displayAuthorAffiliation"}
			{fbvElement type="checkbox" id="displayAuthorCountry" value="1" checked=$displayAuthorCountry label="plugins.generic.articleMetrics.displayAuthorCountry"}
			{fbvElement type="checkbox" id="displayAuthorOrcid" value="1" checked=$displayAuthorOrcid label="plugins.generic.articleMetrics.displayAuthorOrcid"}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormButtons submitText="common.save"}
</form>
