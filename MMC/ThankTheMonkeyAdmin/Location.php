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
    
    class LocationPage extends Page
    {
        protected function DoBeforeCreate()
        {
            $this->dataset = new TableDataset(
                new SqlitePDOConnectionFactory(),
                GetConnectionOptions(),
                '"Location"');
            $field = new IntegerField('primaryKey', null, null, true);
            $this->dataset->AddField($field, true);
            $field = new IntegerField('businessId');
            $this->dataset->AddField($field, false);
            $field = new StringField('phone');
            $this->dataset->AddField($field, false);
            $field = new StringField('address');
            $this->dataset->AddField($field, false);
            $field = new StringField('latitude');
            $this->dataset->AddField($field, false);
            $field = new StringField('longitude');
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
            if (GetCurrentUserGrantForDataSource('Business')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Business'), 'Business.php', $this->RenderText('Businesses'), $currentPageCaption == $this->RenderText('Business')));
            if (GetCurrentUserGrantForDataSource('BusinessType')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('BusinessType'), 'BusinessType.php', $this->RenderText('BusinessType'), $currentPageCaption == $this->RenderText('BusinessType')));
            if (GetCurrentUserGrantForDataSource('Location')->HasViewGrant())
                $result->AddPage(new PageLink($this->RenderText('Location'), 'Location.php', $this->RenderText('Location'), $currentPageCaption == $this->RenderText('Location')));
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
            $grid->SearchControl = new SimpleSearch('Locationssearch', $this->dataset,
                array('primaryKey', 'businessId_name', 'phone', 'address', 'latitude', 'longitude'),
                array($this->RenderText('PrimaryKey'), $this->RenderText('BusinessId'), $this->RenderText('Phone'), $this->RenderText('Address'), $this->RenderText('Latitude'), $this->RenderText('Longitude')),
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
            $this->AdvancedSearchControl = new AdvancedSearchControl('Locationasearch', $this->dataset, $this->GetLocalizerCaptions(), $this->GetColumnVariableContainer(), $this->CreateLinkBuilder());
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
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateLookupSearchInput('businessId', $this->RenderText('BusinessId'), $lookupDataset, 'primaryKey', 'name', false));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('phone', $this->RenderText('Phone')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('address', $this->RenderText('Address')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('latitude', $this->RenderText('Latitude')));
            $this->AdvancedSearchControl->AddSearchColumn($this->AdvancedSearchControl->CreateStringSearchInput('longitude', $this->RenderText('Longitude')));
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
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'BusinessId', 
                'businessId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
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
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'BusinessId', 
                'businessId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
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
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('address_handler');
            
            /* <inline edit column> */
            //
            // Edit column for address field
            //
            $editor = new TextAreaEdit('address_edit', 50, 8);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for address field
            //
            $editor = new TextAreaEdit('address_edit', 50, 8);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for latitude field
            //
            $column = new TextViewColumn('latitude', 'Latitude', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for latitude field
            //
            $editor = new TextEdit('latitude_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Latitude', 'latitude', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for latitude field
            //
            $editor = new TextEdit('latitude_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Latitude', 'latitude', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $column->SetDescription($this->RenderText(''));
            $column->SetFixedWidth(null);
            $grid->AddViewColumn($column);
            
            //
            // View column for longitude field
            //
            $column = new TextViewColumn('longitude', 'Longitude', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for longitude field
            //
            $editor = new TextEdit('longitude_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Longitude', 'longitude', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for longitude field
            //
            $editor = new TextEdit('longitude_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Longitude', 'longitude', $editor, $this->dataset);
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
            $column = new TextViewColumn('businessId_name', 'BusinessId', $this->dataset);
            $column->SetOrderable(true);
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
            $column->SetMaxLength(75);
            $column->SetFullTextWindowHandlerName('address_handler');
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for latitude field
            //
            $column = new TextViewColumn('latitude', 'Latitude', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddSingleRecordViewColumn($column);
            
            //
            // View column for longitude field
            //
            $column = new TextViewColumn('longitude', 'Longitude', $this->dataset);
            $column->SetOrderable(true);
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
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'BusinessId', 
                'businessId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
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
            $editor = new TextAreaEdit('address_edit', 50, 8);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for latitude field
            //
            $editor = new TextEdit('latitude_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Latitude', 'latitude', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddEditColumn($editColumn);
            
            //
            // Edit column for longitude field
            //
            $editor = new TextEdit('longitude_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Longitude', 'longitude', $editor, $this->dataset);
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
            $lookupDataset->SetOrderBy('name', GetOrderTypeAsSQL(otAscending));
            $editColumn = new LookUpEditColumn(
                'BusinessId', 
                'businessId', 
                $editor, 
                $this->dataset, 'primaryKey', 'name', $lookupDataset);
            $validator = new RequiredValidator(StringUtils::Format($this->GetLocalizerCaptions()->GetMessageString('RequiredValidationMessage'), $this->RenderText($editColumn->GetCaption())));
            $editor->GetValidatorCollection()->AddValidator($validator);
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
            $editor = new TextAreaEdit('address_edit', 50, 8);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for latitude field
            //
            $editor = new TextEdit('latitude_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Latitude', 'latitude', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $grid->AddInsertColumn($editColumn);
            
            //
            // Edit column for longitude field
            //
            $editor = new TextEdit('longitude_edit');
            $editor->SetSize(16);
            $editor->SetMaxLength(16);
            $editColumn = new CustomEditColumn('Longitude', 'longitude', $editor, $this->dataset);
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
            // View column for latitude field
            //
            $column = new TextViewColumn('latitude', 'Latitude', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddPrintColumn($column);
            
            //
            // View column for longitude field
            //
            $column = new TextViewColumn('longitude', 'Longitude', $this->dataset);
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
            // View column for latitude field
            //
            $column = new TextViewColumn('latitude', 'Latitude', $this->dataset);
            $column->SetOrderable(true);
            $grid->AddExportColumn($column);
            
            //
            // View column for longitude field
            //
            $column = new TextViewColumn('longitude', 'Longitude', $this->dataset);
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
        
        public function GetModalGridDeleteHandler() { return 'Location_modal_delete'; }
        protected function GetEnableModalGridDelete() { return true; }
    
        protected function CreateGrid()
        {
            $result = new Grid($this, $this->dataset, 'LocationGrid');
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
            // View column for address field
            //
            $column = new TextViewColumn('address', 'Address', $this->dataset);
            $column->SetOrderable(true);
            
            /* <inline edit column> */
            //
            // Edit column for address field
            //
            $editor = new TextAreaEdit('address_edit', 50, 8);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetEditOperationColumn($editColumn);
            /* </inline edit column> */
            
            /* <inline insert column> */
            //
            // Edit column for address field
            //
            $editor = new TextAreaEdit('address_edit', 50, 8);
            $editColumn = new CustomEditColumn('Address', 'address', $editor, $this->dataset);
            $editColumn->SetAllowSetToNull(true);
            $this->ApplyCommonColumnEditProperties($editColumn);
            $column->SetInsertOperationColumn($editColumn);
            /* </inline insert column> */
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'address_handler', $column);
            GetApplication()->RegisterHTTPHandler($handler);//
            // View column for address field
            //
            $column = new TextViewColumn('address', 'Address', $this->dataset);
            $column->SetOrderable(true);
            $handler = new ShowTextBlobHandler($this->dataset, $this, 'address_handler', $column);
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
        $Page = new LocationPage("Location.php", "Location", GetCurrentUserGrantForDataSource("Location"), 'UTF-8');
        $Page->SetShortCaption('Location');
        $Page->SetHeader(GetPagesHeader());
        $Page->SetFooter(GetPagesFooter());
        $Page->SetCaption('Location');
        $Page->SetRecordPermission(GetCurrentUserRecordPermissionsForDataSource("Location"));

        GetApplication()->SetMainPage($Page);
        GetApplication()->Run();
    }
    catch(Exception $e)
    {
        ShowErrorPage($e->getMessage());
    }

?>
