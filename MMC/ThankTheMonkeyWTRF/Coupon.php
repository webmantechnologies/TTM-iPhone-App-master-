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
    
    class CouponPage extends Page
    {
        protected function DoBeforeCreate()
        {
            $this->dataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Coupon"');
            $field = new IntegerField('primaryKey', null, null, true);
            $this->dataset->AddField($field, true);
            $field = new IntegerField('businessId');
            $this->dataset->AddField($field, false);
            $field = new StringField('title');
            $this->dataset->AddField($field, false);
            $field = new StringField('description');
            $this->dataset->AddField($field, false);
            $field = new DateTimeField('startDate');
            $this->dataset->AddField($field, false);
            $field = new DateTimeField('endDate');
            $this->dataset->AddField($field, false);
            $field = new StringField('imageName');
            $this->dataset->AddField($field, false);
            $this->dataset->AddLookupField('businessId', 'Business', new IntegerField('primaryKey'), new StringField('name', 'businessId_name', 'businessId_name_Business'), 'businessId_name_Business');
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
            if (GetCurrentUserGrantForDataSource('WTRF-Businesses')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('WTRF-Businesses'), 'WTRF-Businesses.php', $this->RenderText('WTRF-Businesses'), $currentPageCaption == $this->RenderText('WTRF-Businesses')));
            if (GetCurrentUserGrantForDataSource('WTRF-Coupons')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('WTRF-Coupons'), 'WTRF-Coupons.php', $this->RenderText('WTRF-Coupons'), $currentPageCaption == $this->RenderText('WTRF-Coupons')));
            if (GetCurrentUserGrantForDataSource('WTRF-Locations')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('WTRF-Locations'), 'WTRF-Locations.php', $this->RenderText('WTRF-Locations'), $currentPageCaption == $this->RenderText('WTRF-Locations')));
            
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
            $grid->SearchControl = new SimpleSearch('Couponssearch', $this->dataset,
                array('primaryKey', 'businessId_name', 'title', 'description', 'startDate', 'endDate'),
                array($this->RenderText('PrimaryKey'), $this->RenderText('BusinessId'), $this->RenderText('Title'), $this->RenderText('Description'), $this->RenderText('StartDate'), $this->RenderText('EndDate')),
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
            $this->AdvancedSearchControl = new AdvancedSearchControl('Couponasearch', $this->dataset, $this->GetLocalizerCaptions(), $this->GetColumnVariableContainer(), $this->CreateLinkBuilder());
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('primaryKey', $this->RenderText('PrimaryKey')));
            
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Business"');
            $field = new IntegerField('primaryKey');
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('imageName');
            $lookupDataset->AddField($field, false);
            $field = new StringField('description');
            $lookupDataset->AddField($field, false);
            $field = new StringField('website');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('businessType');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('mediaPartnerId');
            $lookupDataset->AddField($field, false);
            $field = new StringField('videoId');
            $lookupDataset->AddField($field, false);
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('businessId', $this->RenderText('BusinessId'), $lookupDataset, 'primaryKey', 'name', false));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('title', $this->RenderText('Title')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('description', $this->RenderText('Description')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateDateTimeSearchInput('startDate', $this->RenderText('StartDate')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateDateTimeSearchInput('endDate', $this->RenderText('EndDate')));
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
            $column = new TextViewColumn('businessId_name', 'BusinessId', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for businessId field
            //
            $editor = new ComboBox('businessid_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Business"');
            $field = new IntegerField('primaryKey');
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('imageName');
            $lookupDataset->AddField($field, false);
            $field = new StringField('description');
            $lookupDataset->AddField($field, false);
            $field = new StringField('website');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('businessType');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('mediaPartnerId');
            $lookupDataset->AddField($field, false);
            $field = new StringField('videoId');
            $lookupDataset->AddField($field, false);
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'BusinessId', 
                'businessId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for businessId field
            //
            $editor = new ComboBox('businessid_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Business"');
            $field = new IntegerField('primaryKey');
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('imageName');
            $lookupDataset->AddField($field, false);
            $field = new StringField('description');
            $lookupDataset->AddField($field, false);
            $field = new StringField('website');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('businessType');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('mediaPartnerId');
            $lookupDataset->AddField($field, false);
            $field = new StringField('videoId');
            $lookupDataset->AddField($field, false);
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'BusinessId', 
                'businessId', 
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
            // View column for title field
            //
            $column = new TextViewColumn('title', 'Title', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for title field
            //
            $editor = new TextEdit('title_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Title', 'title', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for title field
            //
            $editor = new TextEdit('title_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Title', 'title', $editor, $this->dataset);
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
            // View column for startDate field
            //
            $column = new DateTimeViewColumn('startDate', 'StartDate', $this->dataset);
            $column->SetDateTimeFormat('Y-m-d H:i:s');
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for startDate field
            //
            $editor = new DateTimeEdit('startdate_edit', true, 'Y-m-d H:i:s', 0);
            $editColumn = new CustomEditColumn('StartDate', 'startDate', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for startDate field
            //
            $editor = new DateTimeEdit('startdate_edit', true, 'Y-m-d H:i:s', 0);
            $editColumn = new CustomEditColumn('StartDate', 'startDate', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for endDate field
            //
            $column = new DateTimeViewColumn('endDate', 'EndDate', $this->dataset);
            $column->SetDateTimeFormat('Y-m-d H:i:s');
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for endDate field
            //
            $editor = new DateTimeEdit('enddate_edit', true, 'Y-m-d H:i:s', 0);
            $editColumn = new CustomEditColumn('EndDate', 'endDate', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for endDate field
            //
            $editor = new DateTimeEdit('enddate_edit', true, 'Y-m-d H:i:s', 0);
            $editColumn = new CustomEditColumn('EndDate', 'endDate', $editor, $this->dataset);
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
            $column = new TextViewColumn('businessId_name', 'BusinessId', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for title field
            //
            $column = new TextViewColumn('title', 'Title', $this->dataset);
            $column->SetOrderable(true);
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
            // View column for startDate field
            //
            $column = new DateTimeViewColumn('startDate', 'StartDate', $this->dataset);
            $column->SetDateTimeFormat('Y-m-d H:i:s');
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for endDate field
            //
            $column = new DateTimeViewColumn('endDate', 'EndDate', $this->dataset);
            $column->SetDateTimeFormat('Y-m-d H:i:s');
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for imageName field
            //
            $column = new ExternalImageColumn('imageName', 'ImageName', $this->dataset, '');
            $column->SetSourcePrefix('');
            $column->SetSourceSuffix('');
            $grid->AddSingleRecordViewColumn($column);
        }
    
        protected function AddEditColumns($grid)
        {
            //
            // Edit column for businessId field
            //
            $editor = new ComboBox('businessid_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Business"');
            $field = new IntegerField('primaryKey');
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('imageName');
            $lookupDataset->AddField($field, false);
            $field = new StringField('description');
            $lookupDataset->AddField($field, false);
            $field = new StringField('website');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('businessType');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('mediaPartnerId');
            $lookupDataset->AddField($field, false);
            $field = new StringField('videoId');
            $lookupDataset->AddField($field, false);
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'BusinessId', 
                'businessId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for title field
            //
            $editor = new TextEdit('title_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Title', 'title', $editor, $this->dataset);
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
            // Edit column for startDate field
            //
            $editor = new DateTimeEdit('startdate_edit', true, 'Y-m-d H:i:s', 0);
            $editColumn = new CustomEditColumn('StartDate', 'startDate', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for endDate field
            //
            $editor = new DateTimeEdit('enddate_edit', true, 'Y-m-d H:i:s', 0);
            $editColumn = new CustomEditColumn('EndDate', 'endDate', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for imageName field
            //
            $editor = new ImageUploader('imagename_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('ImageName', 'imageName', $editor, $this->dataset, false, false, 'Coupon');
            $editColumn->OnCustomFileName->AddListener('imageName_GenerateFileName_edit', $this);
            $editColumn->SetReplaceUploadedFileIfExist(true);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
        }
    
        protected function AddInsertColumns($grid)
        {
            //
            // Edit column for businessId field
            //
            $editor = new ComboBox('businessid_edit', $this->GetLocalizerCaptions()->GetMessageString('PleaseSelect'));
            $lookupDataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Business"');
            $field = new IntegerField('primaryKey');
            $lookupDataset->AddField($field, true);
            $field = new StringField('name');
            $lookupDataset->AddField($field, false);
            $field = new StringField('imageName');
            $lookupDataset->AddField($field, false);
            $field = new StringField('description');
            $lookupDataset->AddField($field, false);
            $field = new StringField('website');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('businessType');
            $lookupDataset->AddField($field, false);
            $field = new IntegerField('mediaPartnerId');
            $lookupDataset->AddField($field, false);
            $field = new StringField('videoId');
            $lookupDataset->AddField($field, false);
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'BusinessId', 
                'businessId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for title field
            //
            $editor = new TextEdit('title_edit');
            $editor->SetSize(32);
            $editor->SetMaxLength(32);
            $editColumn = new CustomEditColumn('Title', 'title', $editor, $this->dataset);
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
            // Edit column for startDate field
            //
            $editor = new DateTimeEdit('startdate_edit', true, 'Y-m-d H:i:s', 0);
            $editColumn = new CustomEditColumn('StartDate', 'startDate', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for endDate field
            //
            $editor = new DateTimeEdit('enddate_edit', true, 'Y-m-d H:i:s', 0);
            $editColumn = new CustomEditColumn('EndDate', 'endDate', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for imageName field
            //
            $editor = new ImageUploader('imagename_edit');
            $editor->SetShowImage(true);
            $editColumn = new UploadFileToFolderColumn('ImageName', 'imageName', $editor, $this->dataset, false, false, 'Coupon');
            $editColumn->OnCustomFileName->AddListener('imageName_GenerateFileName_insert', $this);
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
            $column = new TextViewColumn('businessId_name', 'BusinessId', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for title field
            //
            $column = new TextViewColumn('title', 'Title', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for description field
            //
            $column = new TextViewColumn('description', 'Description', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for startDate field
            //
            $column = new DateTimeViewColumn('startDate', 'StartDate', $this->dataset);
            $column->SetDateTimeFormat('Y-m-d H:i:s');
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for endDate field
            //
            $column = new DateTimeViewColumn('endDate', 'EndDate', $this->dataset);
            $column->SetDateTimeFormat('Y-m-d H:i:s');
            $column->SetOrderable(true);
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
            $column = new TextViewColumn('businessId_name', 'BusinessId', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for title field
            //
            $column = new TextViewColumn('title', 'Title', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for description field
            //
            $column = new TextViewColumn('description', 'Description', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for startDate field
            //
            $column = new DateTimeViewColumn('startDate', 'StartDate', $this->dataset);
            $column->SetDateTimeFormat('Y-m-d H:i:s');
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for endDate field
            //
            $column = new DateTimeViewColumn('endDate', 'EndDate', $this->dataset);
            $column->SetDateTimeFormat('Y-m-d H:i:s');
            $column->SetOrderable(true);
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
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'Coupon');
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
        $targetFolder = FormatDatasetFieldsTemplate($this->GetDataset(), 'Coupon');
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
        
        public function GetModalGridDeleteHandler() { return 'Coupon_modal_delete'; }
        protected function GetEnableModalGridDelete() { return true; }
    
        protected function CreateGrid()
        {
            $result = new Grid($this, $this->dataset, 'CouponGrid');
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
            GetApplication()->RegisterHTTPHandler($handler);//
            // View column for description field
            //
            $column = new TextViewColumn('description', 'Description', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'description_handler', $column);
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
        $Page = new CouponPage("Coupon.php", "Coupon", GetCurrentUserGrantForDataSource("Coupon"), 'UTF-8');
        $Page->SetShortCaption('Coupon');
        $Page->SetHeader(GetPagesHeader());
        $Page->SetFooter(GetPagesFooter());
        $Page->SetCaption('Coupon');
        $Page->SetRecordPermission(GetCurrentUserRecordPermissionsForDataSource("Coupon"));

        GetApplication()->SetMainPage($Page);
        GetApplication()->Run();
    }
    catch(Exception $e)
    {
        ShowErrorPage($e->getMessage());
    }

?>
