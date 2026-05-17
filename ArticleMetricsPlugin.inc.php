<?php

/**
 * Copyright (c) 2024 Indaka Barody
 * Distributed under the GNU GPL v3. For full terms see LICENSE or https://www.gnu.org/licenses/gpl-3.0.txt.
 */

import('lib.pkp.classes.plugins.GenericPlugin');

class ArticleMetricsPlugin extends GenericPlugin
{
    public function register($category, $path, $mainContextId = null)
    {

        if (!parent::register($category, $path, $mainContextId)) {
            return false;
        }

        if($this->getEnabled($mainContextId)) {
            HookRegistry::register('Templates::Issue::Issue::Article', array($this, 'addDoiToArticleSummary'));

            $this->addLocaleData();
            $this->addDoiStyleSheet();
        }

        return true;
    }

    private function addDoiStyleSheet()
    {
        $request = Application::get()->getRequest();
        $url = $request->getBaseUrl() . '/' . $this->getPluginPath() . '/styles/article_metrics.css';
        $templateMgr = TemplateManager::getManager($request);
        $templateMgr->addStyleSheet('doiCSS', $url);
    }

    public function addDoiToArticleSummary($hookName, $args)
    {
        $templateMgr =& $args[1];
        $output =& $args[2];

        $submission = $templateMgr->getTemplateVars('article');
        $doiUrl = $this->getArticleDoiUrl($submission);

        $request = Application::get()->getRequest();
        $context = $request->getContext();
        $contextId = $context ? $context->getId() : CONTEXT_ID_NONE;

        $displayAbstractViews = $this->getSetting($contextId, 'displayAbstractViews') !== null ? $this->getSetting($contextId, 'displayAbstractViews') : true;
        $displayDownloads = $this->getSetting($contextId, 'displayDownloads') !== null ? $this->getSetting($contextId, 'displayDownloads') : true;
        $displayDoi = $this->getSetting($contextId, 'displayDoi') !== null ? $this->getSetting($contextId, 'displayDoi') : true;
        $displayAuthorAffiliation = $this->getSetting($contextId, 'displayAuthorAffiliation') !== null ? $this->getSetting($contextId, 'displayAuthorAffiliation') : true;
        $displayAuthorCountry = $this->getSetting($contextId, 'displayAuthorCountry') !== null ? $this->getSetting($contextId, 'displayAuthorCountry') : true;
        $displayAuthorOrcid = $this->getSetting($contextId, 'displayAuthorOrcid') !== null ? $this->getSetting($contextId, 'displayAuthorOrcid') : true;
        $displayPublicationDate = $this->getSetting($contextId, 'displayPublicationDate') !== null ? $this->getSetting($contextId, 'displayPublicationDate') : true;

        $publicationDate = null;
        if (method_exists($submission, 'getCurrentPublication') && $submission->getCurrentPublication()) {
            $publicationDate = $submission->getCurrentPublication()->getData('datePublished');
        } elseif (method_exists($submission, 'getDatePublished') && $submission->getDatePublished()) {
            $publicationDate = $submission->getDatePublished();
        }

        $templateMgr->assign(array(
            'doiUrl' => $doiUrl,
            'displayAbstractViews' => $displayAbstractViews,
            'displayDownloads' => $displayDownloads,
            'displayDoi' => $displayDoi,
            'displayAuthorAffiliation' => $displayAuthorAffiliation,
            'displayAuthorCountry' => $displayAuthorCountry,
            'displayAuthorOrcid' => $displayAuthorOrcid,
            'displayPublicationDate' => $displayPublicationDate,
            'datePublished' => $publicationDate
        ));

        $output .= $templateMgr->fetch($this->getTemplateResource('article_metrics.tpl'));
    }

    private function getArticleDoiUrl($article): ?string
    {
        $publication = $article->getCurrentPublication();
        $doi = $publication->getData('pub-id::doi');

        if(empty($doi)) {
            return null;
        }

        return "https://doi.org/$doi";
    }

    public function getDisplayName()
    {
        return __('plugins.generic.articleMetrics.displayName');
    }

    public function getDescription()
    {
        return __('plugins.generic.articleMetrics.description');
    }

    public function clearCache($hookName, $args)
    {
        $templateMgr = TemplateManager::getManager();
        $templateMgr->clearTemplateCache();
        return false;
    }

    public function getInstallSitePluginSettingsFile()
    {
        return $this->getPluginPath() . '/settings.xml';
    }

    public function getActions($request, $verb) {
        $router = $request->getRouter();
        import('lib.pkp.classes.linkAction.request.AjaxModal');
        return array_merge(
            $this->getEnabled() ? array(
                new LinkAction(
                    'settings',
                    new AjaxModal(
                        $router->url($request, null, null, 'manage', null, array('verb' => 'settings', 'plugin' => $this->getName(), 'category' => 'generic')),
                        $this->getDisplayName()
                    ),
                    __('manager.plugins.settings'),
                    null
                ),
            ) : array(),
            parent::getActions($request, $verb)
        );
    }

    public function manage($args, $request) {
        switch ($request->getUserVar('verb')) {
            case 'settings':
                $context = $request->getContext();
                $contextId = $context ? $context->getId() : CONTEXT_ID_NONE;
                AppLocale::requireComponents(LOCALE_COMPONENT_APP_COMMON,  LOCALE_COMPONENT_PKP_MANAGER);
                $templateMgr = TemplateManager::getManager($request);

                $this->import('ArticleMetricsSettingsForm');
                $form = new ArticleMetricsSettingsForm($this, $contextId);

                if ($request->getUserVar('save')) {
                    $form->readInputData();
                    if ($form->validate()) {
                        $form->execute();
                        $notificationManager = new NotificationManager();
                        $notificationManager->createTrivialNotification($request->getUser()->getId(), NOTIFICATION_TYPE_SUCCESS, array('contents' => __('common.changesSaved')));
                        return new JSONMessage(true);
                    } else {
                        return new JSONMessage(true, $form->fetch($request));
                    }
                } else {
                    $form->initData();
                    return new JSONMessage(true, $form->fetch($request));
                }
        }
        return parent::manage($args, $request);
    }
}
