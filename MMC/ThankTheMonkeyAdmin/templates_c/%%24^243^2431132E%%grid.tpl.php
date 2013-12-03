<div align="center" style="width: 100%" class="pgui-editform">
    <form
        validate="true"
        name="editform"
        id="editform"
        enctype="multipart/form-data"
        method="POST"
        action="<?php echo $this->_tpl_vars['Grid']->GetEditPageAction(); ?>
"
    >

        <?php $_from = $this->_tpl_vars['HiddenValues']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['HiddenValueName'] => $this->_tpl_vars['HiddenValue']):
?>
        <input type="hidden" name="<?php echo $this->_tpl_vars['HiddenValueName']; ?>
" value="<?php echo $this->_tpl_vars['HiddenValue']; ?>
" />
        <?php endforeach; endif; unset($_from); ?>

        <table class="grid" style="width: auto">
            <tr>
                <th class="even" colspan="4"><?php echo $this->_tpl_vars['Title']; ?>
</th>
            </tr>

            <?php if ($this->_tpl_vars['Grid']->GetErrorMessage() != ''): ?>
            <tr>
                <td class="odd grid_error_row" colspan="4">
                    <div class="grid_error_message  grid_message">
                        <strong><?php echo $this->_tpl_vars['Captions']->GetMessageString('ErrorsDuringUpdateProcess'); ?>
</strong>
                        <br><br>
                        <?php echo $this->_tpl_vars['Grid']->GetErrorMessage(); ?>

                    </div>
                </td>
            </tr>
            <?php endif; ?>
            
<?php $_from = $this->_tpl_vars['Grid']->GetEditColumns(); if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['Columns'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['Columns']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['column']):
        $this->_foreach['Columns']['iteration']++;
?>
            <tr class="<?php if (!(1 & ($this->_foreach['Columns']['iteration']-1))): ?>even<?php else: ?>odd<?php endif; ?>">
                <td
                    class="even"
                    style="padding-left:20px; font-weight: bold;">
                        <?php echo $this->_tpl_vars['column']->GetCaption(); ?>

                        <?php if (! $this->_tpl_vars['column']->GetAllowSetToNull()): ?><font color="#FF0000">*</font><?php endif; ?>
                </td>

                <td class="odd" style="border-right-width: 0px; text-align: left; padding-left: 15px;">
<?php echo $this->_tpl_vars['Renderer']->Render($this->_tpl_vars['column']); ?>

                </td>
                
                <td class="odd" style="border-right-width: 0px; white-space: nowrap; padding-right: 5px;">
                <?php if ($this->_tpl_vars['column']->GetShowSetToNullCheckBox()): ?>
                    <input
                        type="checkbox"
                        value="1"
                        id="<?php echo $this->_tpl_vars['column']->GetFieldName(); ?>
_null"
                        name="<?php echo $this->_tpl_vars['column']->GetFieldName(); ?>
_null"<?php if ($this->_tpl_vars['column']->IsValueNull()): ?>
                        checked="checked"<?php endif; ?>/><?php echo $this->_tpl_vars['Captions']->GetMessageString('SetNull'); ?>

                <?php endif; ?>
                
                </td>
                
                <td class="odd" style="border-right-width: 0px; white-space: nowrap; padding-right: 5px;">
                <?php if ($this->_tpl_vars['column']->GetAllowSetToDefault()): ?>
                    <input type="checkbox" value="1" name="<?php echo $this->_tpl_vars['column']->GetFieldName(); ?>
_def" id="<?php echo $this->_tpl_vars['column']->GetFieldName(); ?>
_def"/><?php echo $this->_tpl_vars['Captions']->GetMessageString('SetDefault'); ?>

                <?php endif; ?>
                </td>
            </tr>
<?php endforeach; endif; unset($_from); ?>
            <tr class="editor_buttons" >
                <td colspan="4" style="text-align: left" valign="middle">
                    <font color="#FF0000">*</font> - <?php echo $this->_tpl_vars['Captions']->GetMessageString('RequiredField'); ?>

                </td>
            </tr>
            
            <tr id="errorMessagesRow" style="display: none;">
                <td class="odd grid_error_row" colspan="4">
                    <ul class="editing-error-box">
                    </ul>
                </td>
            </tr>
            
            <tr height="40" class="editor_buttons">
                <td colspan="4" align="center" valign="top" >
                    <div>
                    <table class="layout-row">
                        <tr>
                            <td>
                                <button
                                    class="submit-button"
                                    name="submit1"
                                    value="save"
                                    data-drop-down-list="submit-button-list"
                                    onclick="<?php echo 'WriteWYSIWYGValuesToTheirTextAreas(); if (ValidateSimpleForm($(\'#editform\'), $(\'ul.editing-error-box\'), false)) { document.editform.submit(); } return false;'; ?>
"
                                ><?php echo $this->_tpl_vars['Captions']->GetMessageString('Save'); ?>
</button>

                                <div class="dropdown-button-menu">
                                    <ul id="submit-button-list" style="display: none;">
                                        <li data-value="save"><?php echo $this->_tpl_vars['Captions']->GetMessageString('SaveAndBackToList'); ?>
</li>
                                        <li data-value="saveedit"><?php echo $this->_tpl_vars['Captions']->GetMessageString('SaveAndEdit'); ?>
</li>
                                    </ul>
                                </div>
                            </td>
                            <td>
                                <button
                                    class="reset-button"
                                    type="reset"
                                    onclick="window.location.href='<?php echo $this->_tpl_vars['Grid']->GetReturnUrl(); ?>
'"
                                ><?php echo $this->_tpl_vars['Captions']->GetMessageString('Cancel'); ?>
</button>
                            </td>
                        </tr>
                    </table>
                    </div>
                </td>
            </tr>
            
        </table>
    </form>
</div>
<script type="text/javascript">
<?php echo '
    $(function() {
        require(PhpGen.ModuleList([
            PhpGen.Module.MooTools,
            PhpGen.Module.PG.Editors
        ], true), function()
        {
            PhpGen.InitializeEditorsController(PhpGen.DataOperation.Edit, $(\'body\'));
        });
    });
'; ?>

</script>