


<div id="collapse-group" class="accordion">

	<s:iterator var="orgCata" value="#request.cataList">
		<div class="accordion-group widget-box">
			<div class="accordion-heading">
				<div class="widget-title">
					<a data-toggle="collapse" href="#collapseGOne" data-parent="#collapse-group">
						<span class="icon">
							<i class="icon-magnet"></i>
						</span>
						<h5><s:propety value="orgCata.cataName" /></h5>
					</a>
				</div>
			</div>
		</div>
	</s:iterator>
	
</div>