<?php
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                                   ATTENTION!
 * If you see this message in browser (Internet Explorer, Mozilla firefox, etc.)
 * this means that
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 */


    require_once 'components/utils/check_utils.php';
    CheckPHPVersion();



    require_once 'database_engine/sqlite_engine.php';
    require_once 'components/page.php';
    require_once 'phpgen_settings.php';


    function GetConnectionOptions()
    {
        $result = GetGlobalConnectionOptions();
        GetApplication()->GetUserAuthorizationStrategy()->ApplyIdentityToConnectionOptions($result);
        return $result;
    }

    
    ?><?php
    
    ?><?php
    
    class MediaPartnerPage extends Page
    {
        protected function DoBeforeCreate()
        {
            $this->dataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"MediaPartner"');
            $field = new IntegerField('primaryKey', null, null, true);
            $this->dataset->AddField($field, true);
            $field = new StringField('name');
            $this->dataset->AddField($field, false);
            $field = new StringField('imageName');
            $this->dataset->AddField($field, false);
            $field = new StringField('description');
            $this->dataset->AddField($field, false);
            $field = new StringField('phone');
            $this->dataset->AddField($field, false);
            $field = new StringField('address');
            $this->dataset->AddField($field, false);
            $field = new StringField('website');
            $this->dataset->AddField($field, false);
            $field = new IntegerField('marketId');
            $this->dataset->AddField($field, false);
            $field = new StringField('bannerName');
            $this->dataset->AddField($field, false);
            $this->dataset->AddLookupField('marketId', 'Market', new IntegerField('primaryKey', null, null, true), new StringField('name', 'marketId_name', 'marketId_name_Market'), 'marketId_name_Market');
        }
    
        protected function CreatePageNavigator()
        {
            $result = new CompositePageNavigator($this);
            
            $partitionNavigator = new PageNavigator('pnav', $this, $this->dataset);
            $partitionNavigator->SetRowsPerPage(20);
            $result->AddPageNavigator($partitionNavigator);
            
            return $result;
        }
    
        public function GetPageList()
        {
            $currentPageCaption = $this->GetShortCaption();
            $result = new PageList();
            if (GetCurrentUserGrantForDataSource('Business')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Business'), 'Business.php', $this->RenderText('Businesses'), $currentPageCaption == $this->RenderText('Business')));
            if (GetCurrentUserGrantForDataSource('BusinessType')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('BusinessType'), 'BusinessType.php', $this->RenderText('BusinessType'), $currentPageCaption == $this->RenderText('BusinessType')));
            if (GetCurrentUserGrantForDataSource('Location')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Location'), 'Location.php', $this->RenderText('Location'), $currentPageCaption == $this->RenderText('Location')));
            if (GetCurrentUserGrantForDataSource('Market')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Market'), 'Market.php', $this->RenderText('Market'), $currentPageCaption == $this->RenderText('Market')));
            if (GetCurrentUserGrantForDataSource('MediaPartner')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('MediaPartner'), 'MediaPartner.php', $this->RenderText('MediaPartner'), $currentPageCaption == $this->RenderText('MediaPartner')));
            if (GetCurrentUserGrantForDataSource('Coupon')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Coupon'), 'Coupon.php', $this->RenderText('Coupon'), $currentPageCaption == $this->RenderText('Coupon')));
            
            if ( HasAdminPage() && GetApplication()->HasAdminGrantForCurrentUser() )
              $result->AddPage(new PageLink($this->RenderText('Admin page'), 'phpgen_admin.php', 'Admin page', false, true));
            return $result;
        }
    
        protected function CreateRssGenerator()
        {
            return null;
        }
    
        protected function CreateGridSearchControl($grid)
        {
            $grid->UseFilter = true;
            $grid->SearchControl = new SimpleSearch('MediaPartnerssearch', $this->dataset,
                array('primaryKey', 'name', 'imageName', 'description', 'phone', 'address', 'website', 'marketId_name', 'bannerName'),
                array($this->RenderText('PrimaryKey'), $this->RenderText('Name'), $this->RenderText('ImageName'), $this->RenderText('Description'), $this->RenderText('Phone'), $this->RenderText('Address'), $this->RenderText('Website'), $this->RenderText('MarketId'), $this->RenderText('BannerName')),
                array(
                    '=' => $this->GetLocalizerCaptions()->GetMessageString('equals'),
                    '<>' => $this->GetLocalizerCaptions()->GetMessageString('doesNotEquals'),
                    '<' => $this->GetLocalizerCaptions()->GetMessageString('isLessThan'),
                    '<=' => $this->GetLocalizerCaptions()->GetMessageString('isLessThanOrEqualsTo'),
                    '>' => $this->GetLocalizerCaptions()->GetMessageString('isGreaterThan'),
                    '>=' => $this->GetLocalizerCaptions()->GetMessageString('isGreaterThanOrEqualsTo'),
                    'ILIKE' => $this->GetLocalizerCaptions()->GetMessageString('Like'),
                    'STARTS' => $this->GetLocalizerCaptions()->GetMessageString('StartsWith'),
                    'ENDS' => $this->GetLocalizerCaptions()->GetMessageString('EndsWith'),
                    'CONTAINS' => $this->GetLocalizerCaptions()->GetMessageString('Contains')
                    ), $this->GetLocalizerCaptions(), $this, 'CONTAINS'
                );
        }
    
        protected function CreateGridAdvancedSearchControl($grid)
        {
            $this->AdvancedSearchControl = new AdvancedSearchControl('MediaPartnerasearch', $this->dataset, $this->GetLocalizerCaptions(), $this->GetColumnVariableContainer(), $this->CreateLinkBuilder());
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('primaryKey', $this->RenderText('PrimaryKey')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('name', $this->RenderText('Name')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('imageName', $this->RenderText('ImageName')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('description', $this->RenderText('Description')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('phone', $this->RenderText('Phone')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('address', $this->RenderText('Address')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('website', $this->RenderText('Website')));
            
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Market"');
            $field = new IntegerField('primaryKey', null, null, true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLat');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLon');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('radius');
            $lookupDataset->AddField($field, false);
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('marketId', $this->RenderText('MarketId'), $lookupDataset, 'primaryKey', 'name', false));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('bannerName', $this->RenderText('BannerName')));
        }
    
        protected function AddOperationsColumns($grid)
        {
            $actionsBandName = 'actions';
            $grid->AddBandToBegin($actionsBandName, $this->GetLocalizerCaptions()->GetMessageString('Actions'), true);
            if ($this->GetSecurityInfo()->HasViewGrant())
            {
                $column = $grid->AddViewColumn(new RowOperationByLinkColumn($this->GetLocalizerCaptions()->GetMessageString('View'), OPERATION_VIEW, $this->dataset), $actionsBandName);
                $column->SetImagePath('images/view_action.png');
            }
            if ($this->GetSecurityInfo()->HasEditGrant())
            {
                $column = $grid->AddViewColumn(new RowOperationByLinkColumn($this->GetLocalizerCaptions()->GetMessageString('Edit'), OPERATION_EDIT, $this->dataset), $actionsBandName);
                $column->SetImagePath('images/edit_action.png');
                $column->OnShow->AddListener('ShowEditButtonHandler', $this);
            }
            if ($this->GetSecurityInfo()->HasDeleteGrant())
            {
                $column = $grid->AddViewColumn(new RowOperationByLinkColumn($this->GetLocalizerCaptions()->GetMessageString('Delete'), OPERATION_DELETE, $this->dataset), $actionsBandName);
                $column->SetImagePath('images/delete_action.png');
                $column->OnShow->AddListener('ShowDeleteButtonHandler', $this);
            $column->SetAdditionalAttribute("modal-delete", "true");
            $column->SetAdditionalAttribute("delete-handler-name", $this->GetModalGridDeleteHandler());
            }
            if ($this->GetSecurityInfo()->HasAddGrant())
            {
                $column = $grid->AddViewColumn(new RowOperationByLinkColumn($this->GetLocalizerCaptions()->GetMessageString('Copy'), OPERATION_COPY, $this->dataset), $actionsBandName);
                $column->SetImagePath('images/copy_action.png');
            }
        }
    
        protected function AddFieldColumns($grid)
        {
            //
            // View column for primaryKey field
            //
            $column = new TextViewColumn('primaryKey', 'PrimaryKey', $this->dataset);
            $column->SetOrderable(true);
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for name field
            //
            $column = new TextViewColumn('name', 'Name', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for name field
            //
            $editor = new TextEdit('name_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Name', 'name', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for name field
            //
            $editor = new TextEdit('name_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Name', 'name', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for imageName field
            //
            $column = new ExternalImageColumn('imageName', 'ImageName', $this->dataset, '');
            $column->SetSourcePrefix('');
            $column->SetSourceSuffix('');
            
            /* <inline edit column> */
            //
            // Edit column for imageName field
            //
            $editor = new ImageUploader('imagename_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('ImageName', 'imageName', $editor, $this->dataset, false, false, 'MediaPartner');
            $editColumn->OnCustomFileName->AddListener('imageName_GenerateFileName_inline_edit', $this);
            $editColumn->SetReplaceUploadedFileIfExist(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for imageName field
            //
            $editor = new ImageUploader('imagename_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('ImageName', 'imageName', $editor, $this->dataset, false, false, 'MediaPartner');
            $editColumn->OnCustomFileName->AddListener('imageName_GenerateFileName_inline_insert', $this);
            $editColumn->SetReplaceUploadedFileIfExist(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for description field
            //
            $column = new TextViewColumn('description', 'Description', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('description_handler');
            
            /* <inline edit column> */
            //
            // Edit column for description field
            //
            $editor = new TextAreaEdit('description_edit', 50, 8);
            $editColumn = new CustomEditColumn('Description', 'description', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for description field
            //
            $editor = new TextAreaEdit('description_edit', 50, 8);
            $editColumn = new CustomEditColumn('Description', 'description', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for phone field
            //
            $column = new TextViewColumn('phone', 'Phone', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for phone field
            //
            $editor = new TextEdit('phone_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Phone', 'phone', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for phone field
            //
            $editor = new TextEdit('phone_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Phone', 'phone', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for address field
            //
            $column = new TextViewColumn('address', 'Address', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for address field
            //
            $editor = new TextEdit('address_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for address field
            //
            $editor = new TextEdit('address_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for website field
            //
            $column = new TextViewColumn('website', 'Website', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('website_handler');
            
            /* <inline edit column> */
            //
            // Edit column for website field
            //
            $editor = new TextAreaEdit('website_edit', 50, 8);
            $editColumn = new CustomEditColumn('Website', 'website', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for website field
            //
            $editor = new TextAreaEdit('website_edit', 50, 8);
            $editColumn = new CustomEditColumn('Website', 'website', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for name field
            //
            $column = new TextViewColumn('marketId_name', 'MarketId', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for marketId field
            //
            $editor = new ComboBox('marketid_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Market"');
            $field = new IntegerField('primaryKey', null, null, true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLat');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLon');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('radius');
            $lookupDataset->AddField($field, false);
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'MarketId', 
                'marketId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for marketId field
            //
            $editor = new ComboBox('marketid_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Market"');
            $field = new IntegerField('primaryKey', null, null, true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLat');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLon');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('radius');
            $lookupDataset->AddField($field, false);
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'MarketId', 
                'marketId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for bannerName field
            //
            $column = new ExternalImageColumn('bannerName', 'BannerName', $this->dataset, '');
            $column->SetSourcePrefix('');
            $column->SetSourceSuffix('');
            
            /* <inline edit column> */
            //
            // Edit column for bannerName field
            //
            $editor = new ImageUploader('bannername_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('BannerName', 'bannerName', $editor, $this->dataset, false, false, 'MediaPartner');
            $editColumn->OnCustomFileName->AddListener('bannerName_GenerateFileName_inline_edit', $this);
            $editColumn->SetReplaceUploadedFileIfExist(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for bannerName field
            //
            $editor = new ImageUploader('bannername_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('BannerName', 'bannerName', $editor, $this->dataset, false, false, 'MediaPartner');
            $editColumn->OnCustomFileName->AddListener('bannerName_GenerateFileName_inline_insert', $this);
            $editColumn->SetReplaceUploadedFileIfExist(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
        }
    
        protected function AddSingleRecordViewColumns($grid)
        {
            //
            // View column for primaryKey field
            //
            $column = new TextViewColumn('primaryKey', 'PrimaryKey', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for name field
            //
            $column = new TextViewColumn('name', 'Name', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for imageName field
            //
            $column = new ExternalImageColumn('imageName', 'ImageName', $this->dataset, '');
            $column->SetSourcePrefix('');
            $column->SetSourceSuffix('');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for description field
            //
            $column = new TextViewColumn('description', 'Description', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('description_handler');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for phone field
            //
            $column = new TextViewColumn('phone', 'Phone', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for address field
            //
            $column = new TextViewColumn('address', 'Address', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for website field
            //
            $column = new TextViewColumn('website', 'Website', $this->dataset);
            $column->SetOrderable(true);
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('website_handler');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for name field
            //
            $column = new TextViewColumn('marketId_name', 'MarketId', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for bannerName field
            //
            $column = new ExternalImageColumn('bannerName', 'BannerName', $this->dataset, '');
            $column->SetSourcePrefix('');
            $column->SetSourceSuffix('');
            $grid->AddSingleRecordViewColumn($column);
        }
    
        protected function AddEditColumns($grid)
        {
            //
            // Edit column for name field
            //
            $editor = new TextEdit('name_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Name', 'name', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for imageName field
            //
            $editor = new ImageUploader('imagename_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('ImageName', 'imageName', $editor, $this->dataset, false, false, 'MediaPartner');
            $editColumn->OnCustomFileName->AddListener('imageName_GenerateFileName_edit', $this);
            $editColumn->SetReplaceUploadedFileIfExist(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for description field
            //
            $editor = new TextAreaEdit('description_edit', 50, 8);
            $editColumn = new CustomEditColumn('Description', 'description', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for phone field
            //
            $editor = new TextEdit('phone_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Phone', 'phone', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for address field
            //
            $editor = new TextEdit('address_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for website field
            //
            $editor = new TextAreaEdit('website_edit', 50, 8);
            $editColumn = new CustomEditColumn('Website', 'website', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for marketId field
            //
            $editor = new ComboBox('marketid_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Market"');
            $field = new IntegerField('primaryKey', null, null, true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLat');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLon');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('radius');
            $lookupDataset->AddField($field, false);
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'MarketId', 
                'marketId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for bannerName field
            //
            $editor = new ImageUploader('bannername_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('BannerName', 'bannerName', $editor, $this->dataset, false, false, 'MediaPartner');
            $editColumn->OnCustomFileName->AddListener('bannerName_GenerateFileName_edit', $this);
            $editColumn->SetReplaceUploadedFileIfExist(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
        }
    
        protected function AddInsertColumns($grid)
        {
            //
            // Edit column for name field
            //
            $editor = new TextEdit('name_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Name', 'name', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for imageName field
            //
            $editor = new ImageUploader('imagename_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('ImageName', 'imageName', $editor, $this->dataset, false, false, 'MediaPartner');
            $editColumn->OnCustomFileName->AddListener('imageName_GenerateFileName_insert', $this);
            $editColumn->SetReplaceUploadedFileIfExist(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for description field
            //
            $editor = new TextAreaEdit('description_edit', 50, 8);
            $editColumn = new CustomEditColumn('Description', 'description', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for phone field
            //
            $editor = new TextEdit('phone_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Phone', 'phone', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for address field
            //
            $editor = new TextEdit('address_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for website field
            //
            $editor = new TextAreaEdit('website_edit', 50, 8);
            $editColumn = new CustomEditColumn('Website', 'website', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for marketId field
            //
            $editor = new ComboBox('marketid_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Market"');
            $field = new IntegerField('primaryKey', null, null, true);
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLat');
            $lookupDataset->AddField($field, false);
            $field = new StringField('geoCenterLon');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('radius');
            $lookupDataset->AddField($field, false);
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'MarketId', 
                'marketId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for bannerName field
            //
            $editor = new ImageUploader('bannername_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('BannerName', 'bannerName', $editor, $this->dataset, false, false, 'MediaPartner');
            $editColumn->OnCustomFileName->AddListener('bannerName_GenerateFileName_insert', $this);
            $editColumn->SetReplaceUploadedFileIfExist(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            if ($this->GetSecurityInfo()->HasAddGrant())
            {
                $grid->SetShowAddButton(true);
                $grid->SetShowInlineAddButton(false);
            }
            else
            {
                $grid->SetShowInlineAddButton(false);
                $grid->SetShowAddButton(false);
            }
        }
    
        protected function AddPrintColumns($grid)
        {
            //
            // View column for primaryKey field
            //
            $column = new TextViewColumn('primaryKey', 'PrimaryKey', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for name field
            //
            $column = new TextViewColumn('name', 'Name', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for imageName field
            //
            $column = new ExternalImageColumn('imageName', 'ImageName', $this->dataset, '');
            $column->SetSourcePrefix('');
            $column->SetSourceSuffix('');
            $grid->AddPrintColumn($column);
            
            //
            // View column for description field
            //
            $column = new TextViewColumn('description', 'Description', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for phone field
            //
            $column = new TextViewColumn('phone', 'Phone', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for address field
            //
            $column = new TextViewColumn('address', 'Address', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for website field
            //
            $column = new TextViewColumn('website', 'Website', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for name field
            //
            $column = new TextViewColumn('marketId_name', 'MarketId', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for bannerName field
            //
            $column = new ExternalImageColumn('bannerName', 'BannerName', $this->dataset, '');
            $column->SetSourcePrefix('');
            $column->SetSourceSuffix('');
            $grid->AddPrintColumn($column);
        }
    
        protected function AddExportColumns($grid)
        {
            //
            // View column for primaryKey field
            //
            $column = new TextViewColumn('primaryKey', 'PrimaryKey', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for name field
            //
            $column = new TextViewColumn('name', 'Name', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for imageName field
            //
            $column = new ExternalImageColumn('imageName', 'ImageName', $this->dataset, '');
            $column->SetSourcePrefix('');
            $column->SetSourceSuffix('');
            $grid->AddExportColumn($column);
            
            //
            // View column for description field
            //
            $column = new TextViewColumn('description', 'Description', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for phone field
            //
            $column = new TextViewColumn('phone', 'Phone', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for address field
            //
            $column = new TextViewColumn('address', 'Address', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for website field
            //
            $column = new TextViewColumn('website', 'Website', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for name field
            //
            $column = new TextViewColumn('marketId_name', 'MarketId', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for bannerName field
            //
            $column = new ExternalImageColumn('bannerName', 'BannerName', $this->dataset, '');
            $column->SetSourcePrefix('');
            $column->SetSourceSuffix('');
            $grid->AddExportColumn($column);
        }
    
        public function GetPageDirection()
        {
            return null;
        }
    
        protected function ApplyCommonColumnEditProperties($column)
        {
            $column->SetShowSetToNullCheckBox(true);
    	$column->SetVariableContainer($this->GetColumnVariableContainer());
        }
    
        public function imageName_GenerateFileName_inline_edit(&$filepath, &$handled, $original_file_name, $original_file_extension, $file_size)
        {
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'MediaPartner');
        FileUtils::ForceDirectories($targetFolder);
        
        $filename = ApplyVarablesMapToTemplate('%original_file_name%',
            array(
                'original_file_name' => $original_file_name,
                'original_file_extension' => $original_file_extension,
                'file_size' => $file_size
            )
        );
        $filepath = Path::Combine($targetFolder, $filename);
        
        $handled = true;
        }
        
        public function imageName_GenerateFileName_inline_insert(&$filepath, &$handled, $original_file_name, $original_file_extension, $file_size)
        {
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'MediaPartner');
        FileUtils::ForceDirectories($targetFolder);
        
        $filename = ApplyVarablesMapToTemplate('%original_file_name%',
            array(
                'original_file_name' => $original_file_name,
                'original_file_extension' => $original_file_extension,
                'file_size' => $file_size
            )
        );
        $filepath = Path::Combine($targetFolder, $filename);
        
        $handled = true;
        }
        public function bannerName_GenerateFileName_inline_edit(&$filepath, &$handled, $original_file_name, $original_file_extension, $file_size)
        {
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'MediaPartner');
        FileUtils::ForceDirectories($targetFolder);
        
        $filename = ApplyVarablesMapToTemplate('%original_file_name%',
            array(
                'original_file_name' => $original_file_name,
                'original_file_extension' => $original_file_extension,
                'file_size' => $file_size
            )
        );
        $filepath = Path::Combine($targetFolder, $filename);
        
        $handled = true;
        }
        
        public function bannerName_GenerateFileName_inline_insert(&$filepath, &$handled, $original_file_name, $original_file_extension, $file_size)
        {
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'MediaPartner');
        FileUtils::ForceDirectories($targetFolder);
        
        $filename = ApplyVarablesMapToTemplate('%original_file_name%',
            array(
                'original_file_name' => $original_file_name,
                'original_file_extension' => $original_file_extension,
                'file_size' => $file_size
            )
        );
        $filepath = Path::Combine($targetFolder, $filename);
        
        $handled = true;
        }
        
        function GetCustomClientScript()
        {
            return ;
        }
        
        function GetOnPageLoadedClientScript()
        {
            return ;
        }
        public function imageName_GenerateFileName_edit(&$filepath, &$handled, $original_file_name, $original_file_extension, $file_size)
        {
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'MediaPartner');
        FileUtils::ForceDirectories($targetFolder);
        
        $filename = ApplyVarablesMapToTemplate('%original_file_name%',
            array(
                'original_file_name' => $original_file_name,
                'original_file_extension' => $original_file_extension,
                'file_size' => $file_size
            )
        );
        $filepath = Path::Combine($targetFolder, $filename);
        
        $handled = true;
        }
        public function bannerName_GenerateFileName_edit(&$filepath, &$handled, $original_file_name, $original_file_extension, $file_size)
        {
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'MediaPartner');
        FileUtils::ForceDirectories($targetFolder);
        
        $filename = ApplyVarablesMapToTemplate('%original_file_name%',
            array(
                'original_file_name' => $original_file_name,
                'original_file_extension' => $original_file_extension,
                'file_size' => $file_size
            )
        );
        $filepath = Path::Combine($targetFolder, $filename);
        
        $handled = true;
        }
        public function imageName_GenerateFileName_insert(&$filepath, &$handled, $original_file_name, $original_file_extension, $file_size)
        {
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'MediaPartner');
        FileUtils::ForceDirectories($targetFolder);
        
        $filename = ApplyVarablesMapToTemplate('%original_file_name%',
            array(
                'original_file_name' => $original_file_name,
                'original_file_extension' => $original_file_extension,
                'file_size' => $file_size
            )
        );
        $filepath = Path::Combine($targetFolder, $filename);
        
        $handled = true;
        }
        public function bannerName_GenerateFileName_insert(&$filepath, &$handled, $original_file_name, $original_file_extension, $file_size)
        {
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'MediaPartner');
        FileUtils::ForceDirectories($targetFolder);
        
        $filename = ApplyVarablesMapToTemplate('%original_file_name%',
            array(
                'original_file_name' => $original_file_name,
                'original_file_extension' => $original_file_extension,
                'file_size' => $file_size
            )
        );
        $filepath = Path::Combine($targetFolder, $filename);
        
        $handled = true;
        }
        public function ShowEditButtonHandler($show)
        {
            if ($this->GetRecordPermission() != null)
                $show = $this->GetRecordPermission()->HasEditGrant($this->GetDataset());
        }
        public function ShowDeleteButtonHandler($show)
        {
            if ($this->GetRecordPermission() != null)
                $show = $this->GetRecordPermission()->HasDeleteGrant($this->GetDataset());
        }
        
        public function GetModalGridDeleteHandler() { return 'MediaPartner_modal_delete'; }
        protected function GetEnableModalGridDelete() { return true; }
    
        protected function CreateGrid()
        {
            $result = new Grid($this, $this->dataset, 'MediaPartnerGrid');
            if ($this->GetSecurityInfo()->HasDeleteGrant())
               $result->SetAllowDeleteSelected(true);
            else
               $result->SetAllowDeleteSelected(false);   
            
            ApplyCommonPageSettings($this, $result);
            
            $result->SetUseImagesForActions(true);
            $result->SetUseFixedHeader(false);
            
            $result->SetShowLineNumbers(false);
            
            $result->SetHighlightRowAtHover(false);
            $result->SetWidth('');
            $this->CreateGridSearchControl($result);
            $this->CreateGridAdvancedSearchControl($result);
            $this->AddOperationsColumns($result);
            $this->AddFieldColumns($result);
            $this->AddSingleRecordViewColumns($result);
            $this->AddEditColumns($result);
            $this->AddInsertColumns($result);
            $this->AddPrintColumns($result);
            $this->AddExportColumns($result);
    
            $this->SetShowPageList(true);
            $this->SetExportToExcelAvailable(true);
            $this->SetExportToWordAvailable(true);
            $this->SetExportToXmlAvailable(true);
            $this->SetExportToCsvAvailable(true);
            $this->SetExportToPdfAvailable(true);
            $this->SetPrinterFriendlyAvailable(true);
            $this->SetSimpleSearchAvailable(true);
            $this->SetAdvancedSearchAvailable(true);
            $this->SetVisualEffectsEnabled(true);
            $this->SetShowTopPageNavigator(true);
            $this->SetShowBottomPageNavigator(true);
    
            //
            // Http Handlers
            //
            //
            // View column for description field
            //
            $column = new TextViewColumn('description', 'Description', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for description field
            //
            $editor = new TextAreaEdit('description_edit', 50, 8);
            $editColumn = new CustomEditColumn('Description', 'description', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for description field
            //
            $editor = new TextAreaEdit('description_edit', 50, 8);
            $editColumn = new CustomEditColumn('Description', 'description', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'description_handler', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            //
            // View column for website field
            //
            $column = new TextViewColumn('website', 'Website', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for website field
            //
            $editor = new TextAreaEdit('website_edit', 50, 8);
            $editColumn = new CustomEditColumn('Website', 'website', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for website field
            //
            $editor = new TextAreaEdit('website_edit', 50, 8);
            $editColumn = new CustomEditColumn('Website', 'website', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'website_handler', $column);
            GetApplication()->RegisterHTTPHandler($handler);//
            // View column for description field
            //
            $column = new TextViewColumn('description', 'Description', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'description_handler', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            //
            // View column for website field
            //
            $column = new TextViewColumn('website', 'Website', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'website_handler', $column);
            GetApplication()->RegisterHTTPHandler($handler);
            return $result;
        }
        
        protected function OpenAdvancedSearchByDefault()
        {
            return false;
        }
    
        protected function DoGetGridHeader()
        {
            return '';
        }
    }



    try
    {
        $Page = new MediaPartnerPage("MediaPartner.php", "MediaPartner", GetCurrentUserGrantForDataSource("MediaPartner"), 'UTF-8');
        $Page->SetShortCaption('MediaPartner');
        $Page->SetHeader(GetPagesHeader());
        $Page->SetFooter(GetPagesFooter());
        $Page->SetCaption('MediaPartner');
        $Page->SetRecordPermission(GetCurrentUserRecordPermissionsForDataSource("MediaPartner"));

        GetApplication()->SetMainPage($Page);
        GetApplication()->Run();
    }
    catch(Exception $e)
    {
        ShowErrorPage($e->getMessage());
    }

?>
