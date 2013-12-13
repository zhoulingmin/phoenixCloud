


<div id="collapse-group" class="accordion">
	<s:iterator value="#request.cataList">
		<div class="accordion-group widget-box" cataId=<s:property value="orgCataId"/>>
			<div class="accordion-heading">
				<div class="widget-title">
					<a data-toggle="collapse" href="#orgCata-<s:property value="orgCataId"/>" data-parent="#collapse-group">
						<span class="icon">
							<i class="icon-folder-close"></i>
							<input id="cata-<s:property value="orgCataId"/>" type="checkbox" style="margin-bottom:5px;" value="<s:property value="orgCataId"/>" />
						</span>
						<h5><s:property value="cataName" /></h5>
					</a>
				</div>
			</div>
		</div>
	</s:iterator>
</div>
