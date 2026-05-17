<?php

/**
 * @file ArticleMetricsSettingsForm.inc.php
 *
 * Copyright (c) 2024 Indaka Barody
 * Distributed under the GNU GPL v3. For full terms see LICENSE or https://www.gnu.org/licenses/gpl-3.0.txt.
 *
 * @class ArticleMetricsSettingsForm
 * @brief Form for journal managers to modify Article Metrics plugin settings
 */

import('lib.pkp.classes.form.Form');

class ArticleMetricsSettingsForm extends Form {
	/** @var int */
	var $_contextId;

	/** @var object */
	var $_plugin;

	/**
	 * Constructor
	 * @param $plugin ArticleMetricsPlugin
	 * @param $contextId int
	 */
	function __construct($plugin, $contextId) {
		$this->_contextId = $contextId;
		$this->_plugin = $plugin;

		parent::__construct($plugin->getTemplateResource('settings.tpl'));

		$this->addCheck(new FormValidatorPost($this));
		$this->addCheck(new FormValidatorCSRF($this));
	}

	/**
	 * Initialize form data.
	 */
	function initData() {
		$contextId = $this->_contextId;
		$plugin = $this->_plugin;

        $displayAbstractViews = $plugin->getSetting($contextId, 'displayAbstractViews');
        $displayDownloads = $plugin->getSetting($contextId, 'displayDownloads');
        $displayDoi = $plugin->getSetting($contextId, 'displayDoi');
        $displayAuthorAffiliation = $plugin->getSetting($contextId, 'displayAuthorAffiliation');
        $displayAuthorCountry = $plugin->getSetting($contextId, 'displayAuthorCountry');

		$this->setData('displayAbstractViews', $displayAbstractViews !== null ? $displayAbstractViews : true);
		$this->setData('displayDownloads', $displayDownloads !== null ? $displayDownloads : true);
		$this->setData('displayDoi', $displayDoi !== null ? $displayDoi : true);
		$this->setData('displayAuthorAffiliation', $displayAuthorAffiliation !== null ? $displayAuthorAffiliation : true);
		$this->setData('displayAuthorCountry', $displayAuthorCountry !== null ? $displayAuthorCountry : true);
		$this->setData('displayAuthorOrcid', $plugin->getSetting($contextId, 'displayAuthorOrcid') !== null ? $plugin->getSetting($contextId, 'displayAuthorOrcid') : true);
		$this->setData('displayPublicationDate', $plugin->getSetting($contextId, 'displayPublicationDate') !== null ? $plugin->getSetting($contextId, 'displayPublicationDate') : true);
	}

	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(array(
			'displayAbstractViews',
			'displayDownloads',
			'displayDoi',
			'displayAuthorAffiliation',
			'displayAuthorCountry',
			'displayAuthorOrcid',
			'displayPublicationDate'
		));
	}

	/**
	 * Fetch the form.
	 * @copydoc Form::fetch()
	 */
	function fetch($request, $template = null, $display = false) {
		$templateMgr = TemplateManager::getManager($request);
		$templateMgr->assign('pluginName', $this->_plugin->getName());
		return parent::fetch($request, $template, $display);
	}

	/**
	 * Save settings.
	 */
	function execute(...$functionArgs) {
		$plugin = $this->_plugin;
		$contextId = $this->_contextId;

		$plugin->updateSetting($contextId, 'displayAbstractViews', $this->getData('displayAbstractViews') ? true : false, 'bool');
		$plugin->updateSetting($contextId, 'displayDownloads', $this->getData('displayDownloads') ? true : false, 'bool');
		$plugin->updateSetting($contextId, 'displayDoi', $this->getData('displayDoi') ? true : false, 'bool');
		$plugin->updateSetting($contextId, 'displayAuthorAffiliation', $this->getData('displayAuthorAffiliation') ? true : false, 'bool');
		$plugin->updateSetting($contextId, 'displayAuthorCountry', $this->getData('displayAuthorCountry') ? true : false, 'bool');
		$plugin->updateSetting($contextId, 'displayAuthorOrcid', $this->getData('displayAuthorOrcid') ? true : false, 'bool');
		$plugin->updateSetting($contextId, 'displayPublicationDate', $this->getData('displayPublicationDate') ? true : false, 'bool');

		parent::execute(...$functionArgs);
	}
}
