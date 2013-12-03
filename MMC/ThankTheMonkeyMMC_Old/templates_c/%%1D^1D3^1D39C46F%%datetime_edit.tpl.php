<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('block', 'style_block', 'editors/datetime_edit.tpl', 9, false),)), $this); ?>
<?php if (! $this->_tpl_vars['DateTimeEdit']->GetReadOnly()): ?>
<?php if ($this->_tpl_vars['RenderText']): ?>
<span>
    <input
        data-editor="true"
        data-editor-class="DateTimeEdit"
        data-field-name="<?php echo $this->_tpl_vars['DateTimeEdit']->GetFieldName(); ?>
"
        data-editable="true"
        <?php $this->_tag_stack[] = array('style_block', array()); $_block_repeat=true;smarty_block_style_block($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
            <?php echo $this->_tpl_vars['DateTimeEdit']->GetCustomAttributes(); ?>

        <?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_style_block($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
        class="pgui-date-time-edit" type="text" name="<?php echo $this->_tpl_vars['DateTimeEdit']->GetName(); ?>
" id="<?php echo $this->_tpl_vars['DateTimeEdit']->GetName(); ?>
" value="<?php echo $this->_tpl_vars['DateTimeEdit']->GetValue(); ?>
" <?php echo $this->_tpl_vars['Validators']['InputAttributes']; ?>
>
    <div title="Show date time picker" href="#" class="pgui-date-time-edit-picker" id="<?php echo $this->_tpl_vars['DateTimeEdit']->GetName(); ?>
_trigger"></div>
</span>
<?php endif; ?>
<?php if ($this->_tpl_vars['RenderScripts']): ?>
<?php if ($this->_tpl_vars['RenderText']): ?>
<script type="text/javascript">
<?php endif; ?>
    <?php echo '
    require(PhpGen.ModuleList(PhpGen.Module.Calendar), function(){
        Calendar.setup({
            '; ?>

            inputField     :    "<?php echo $this->_tpl_vars['DateTimeEdit']->GetName(); ?>
",
            dateFormat     :    "<?php echo $this->_tpl_vars['DateTimeEdit']->GetFormat(); ?>
",
            showTime       :    <?php if ($this->_tpl_vars['DateTimeEdit']->GetShowsTime()): ?>true<?php else: ?>false<?php endif; ?>,
            trigger        :    "<?php echo $this->_tpl_vars['DateTimeEdit']->GetName(); ?>
_trigger",
            minuteStep     :    1,
            onSelect       :    function() { this.hide(); PhpGen.dateTimeGlobalNotifier.valueChanged("<?php echo $this->_tpl_vars['DateTimeEdit']->GetFieldName(); ?>
"); },
            fdow           :    <?php echo $this->_tpl_vars['DateTimeEdit']->GetFirstDayOfWeek(); ?>

            <?php echo '
        });
    });
    '; ?>

<?php if ($this->_tpl_vars['RenderText']): ?>
</script>
<?php endif; ?>
<?php endif; ?>
<?php else: ?>
<?php if ($this->_tpl_vars['RenderText']): ?>
<span
    data-editor="true"
    data-editor-class="DateTimeEdit"
    data-field-name="<?php echo $this->_tpl_vars['DateTimeEdit']->GetFieldName(); ?>
"
    data-editable="false"
    ><?php echo $this->_tpl_vars['DateTimeEdit']->GetValue(); ?>
</span>
<?php endif; ?>
<?php endif; ?>