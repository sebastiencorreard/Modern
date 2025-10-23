<!-- BEGIN of default/visitor -->
!! WIMS main entrance page theme.
!nocache

!if $module!=home
  <!-- END of default/visitor (not in Home) -->
  !exit
!endif
!if $wims_theme!=default
  <!-- END of default/visitor (not in default) -->
  !exit
!endif

</div>

!set home_theme=yes
!set table_colors=$wims_ref_bgcolor,$wims_ref_bgcolor
!read themes/_procs/table.proc
<div id="visitor_home">

 !read themes/$wims_theme/_widgets/site_title.phtml
!set wims_headmenu_colcnt=6
!set table_class=wimsmenu
$table_header
$table_tr<td>
  !href module=adm/new $wims_name_mod_new
</td><td>
  !href module=adm/browse $wims_name_browse
</td><td>
  !href module=adm/forum/forum $wims_name_forum
</td><td>
  !href module=adm/light&phtml=mirror.phtml.$lang $wims_name_mirror
</td><td>
  !href module=adm/light&phtml=useropts.phtml.$lang $wims_name_pref
</td><td>
  !href module=help/main $wims_name_help
</td></tr>
$table_tr<td colspan="$wims_headmenu_colcnt">
  !read themes/$wims_theme/_widgets/language_selector.phtml
</td></tr>
$table_end

!if $gotcnt<=0 and $s_keywords=$empty
  !read themes/$wims_theme/_widgets/virtualzone.phtml
!endif
</div>
<div class="wimsbody">

!read themes/_widgets/manager.phtml

!read ./form.phtml
!if $s_category=V
  <!-- Foundation XY grid -->
  <link rel="stylesheet" href="html/themes/_css/foundation_xygrid.css">
  !! from home module
  !read ./front.phtml
!else
  !read ./result.phtml
!endif


</div>
<div class="wimstail">

$table_header
$table_tr
!read themes/$wims_theme/_widgets/devtools.phtml
</tr>
!if $gotcnt<=0 and $s_keywords=$empty
 $table_tr
 !read themes/$wims_theme/_widgets/documentation.phtml
 !read themes/$wims_theme/_widgets/site.phtml
 </tr>
!endif
$table_end
!read themes/_widgets/visitorcredits.phtml

!robottrap
</div>
</body>
<!-- end of default/visitor -->
</html>
