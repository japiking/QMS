/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */
/*
CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
};
*/
CKEDITOR.editorConfig = function( config )
{
    // Define changes to default configuration here. For example:
    // config.language = 'fr';
    // config.uiColor = '#AADC6E';
 
  config.docType = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
  config.font_defaultLabel = '±º∏≤';
  config.font_names = '±º∏≤/Gulim;µ∏øÚ/Dotum;πŸ≈¡/Batang;±√º≠/Gungsuh;Arial/Arial;Comic Sans MS/Comic Sans MS;Courier New/Courier New;Georgia/Georgia;Lucida Sans Unicode/Lucida Sans Unicode;Tahoma/Tahoma;Times New Roman/Times New Roman;Trebuchet MS/Trebuchet MS;Verdana/Verdana';
  config.fontSize_defaultLabel = '12px';
  config.fontSize_sizes = '8/8px;9/9px;10/10px;11/11px;12/12px;14/14px;16/16px;18/18px;20/20px;22/22px;24/24px;26/26px;28/28px;36/36px;48/48px;';
  config.language = "ko";
  config.resize_enabled = true;
  config.enterMode = CKEDITOR.ENTER_BR;
  config.shiftEnterMode = CKEDITOR.ENTER_P;
  config.startupFocus = false;
  config.uiColor = '#eaebe7';
  config.toolbarCanCollapse = false;
  config.menu_subMenuDelay = 0;
  config.width ='100%';
  config.height ='250';
  config.toolbar = [['Bold','Italic','Underline','Strike','-','Subscript','Superscript','-','TextColor','BGColor','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','Link','Unlink','-','Find','Replace','SelectAll','RemoveFormat','-','Image','Flash','Table','Smiley','SpecialChar'],'/',['Source','Preview','-','ShowBlocks','-','Font','FontSize','Cut','Copy','Paste','PasteText','PasteFromWord','Undo','Redo','-','Maximize','About']];
  
  config.filebrowserUploadUrl = '/QMS/jsp/proc/bbs/bbs_fileupload_do.jsp';
};