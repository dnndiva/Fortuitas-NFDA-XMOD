<xmod:Select>
  <Case CompareType="text" Value='[[Url:search]]' Operator="<>" Expression="">          
      <div class="showClearBtn">
        <h1 class="h5-heading"><span class="text-grey">Searching:</span> 
          [[Url:search]] 
          <xmod:Select>
            <Case CompareType="text" Value='[[Url:category]]' Operator="<>" Expression="">           
          - [[Url:category]]
            </Case>
          </xmod:Select>
        </h1>    
      </div>    
  </Case>
  <else>
    
  </else>
</xmod:Select>






<xmod:Template UsePaging="True" Ajax="True" AddRoles="Administrators" EditRoles="Administrators" DeleteRoles="Administrators" DetailRoles="Unauthenticated Users,Registered Users,Administrators">

  <ListDataSource CommandText="
    SELECT DISTINCT
       *       
    FROM (
      SELECT DISTINCT 
         [AccountNumber]
        ,[Name]
        ,[StreetAddress1]
        ,[City]
        ,[State]
        ,[PostalCode]
        ,Country
        ,PrimaryContact
        ,Website
        ,Email
        ,Phone        
        ,[NfdaSponsorshipLevel]
				,dbo.[ufn_StringArray_NFDA_SupplierCategories](AccountNumber) AS AssociatedCategories    
        ,Logo                           
      FROM NFDA_Supplier
    ) AS Results   
		WHERE 
      (
       	@passedSearch='-1'
       	OR (@passedSearch<>'-1' AND Name LIKE '%' +@passedSearch+ '%')                                 
      ) 
       AND                        
      (
       	@passedCategory='-1'
       	OR (@passedCategory<>'-1' AND AssociatedCategories LIKE '%' +@passedCategory+ '%')                                 
      )                               
    Order By AccountNumber DESC
  ">
        <parameter name="passedSearch" value='[[Url:search]]' defaultvalue="-1" datatype="string" />
    		<parameter name="passedCategory" value='[[Url:category]]' defaultvalue="-1" datatype="string" />  
  </ListDataSource>
  
  <DetailDataSource CommandText="
    SELECT 
       *
      ,dbo.[ufn_StringArray_NFDA_SupplierCategories](AccountNumber) AS AssociatedCategories
    FROM (
      SELECT DISTINCT 
        id
        ,AccountNumber
        ,Name
        ,Type
        ,StreetAddress1
        ,City
        ,State
        ,PostalCode
        ,Country
        ,AddressComposite
        ,Latitude
        ,Longitude
        ,PrimaryContact
        ,Website
        ,Email
        ,Phone
        ,NfdaInternationShipper
        ,NfdaSponsorshipLevel
        ,Category
        ,Logo
        --Attributes
      FROM NFDA_Supplier
    ) AS Results
    WHERE AccountNumber = @AccountNumber
  ">
    <Parameter Name="AccountNumber" />
  </DetailDataSource>  
  

<SearchSort
      FilterExpression="[Name] LIKE '%{0}%' or [PrimaryContact] LIKE '%{0}%' or [AccountNumber] LIKE '%{0}%' or [City] LIKE '%{0}%' or [State] LIKE '%{0}%' or [Country] LIKE '%{0}%' or [PostalCode] LIKE '%{0}%'"
      SearchLabelText="Supplier Search Results:" SearchButtonText="GO"
      SortFieldNames="Name,City,State,NfdaSponsorshipLevel,logo,phone,email,website"
      SortFieldLabels="Name,City,State,Sponsorship Level,logo,phone,email,website"
      SearchBoxCssClass="form-control"
      SearchButtonCssClass="btn btn-default"
      SortButtonText="Go"
      SortButtonCssClass="btn btn-default"
      SortFieldListCssClass="form-control">
  		<div class="row">
        <div class="col-xs-12 col-sm-9">
        	<h5>{SearchLabel}</h5>    
        </div>    
        <div class="col-xs-12 col-sm-3">

          <div class="form-inline text-right">
            <div class="form-group text-right">
              <label class="control-label">Sort</label>
              {SortFieldList}
              {SortButton}
            </div>            
            <div class="form-group text-right">
              <div class="checkbox text-right">
                <label>
                  &nbsp;&nbsp; {ReverseSort} Reverse
                </label>
              </div>
            </div>
          </div>  


        </div>  	
  		</div>
      <!--div class="row">        
        <div class="col text-center">
          <div class="input-group">            
            {SearchBox}
            <span class="input-group-btn">
              {SearchButton}
            </span>
          </div>
        </div>
        <div class="col text-center">
          <div class="form-inline">
            <div class="form-group">
              <label class="control-label">Sort</label>
              {SortFieldList}
              {SortButton}
            </div>
            <div class="form-group">
              <div class="checkbox">
                <label>
                  &nbsp;&nbsp; XX ReverseSort XX Reverse
                </label>
              </div>
            </div>
          </div>  
        </div>
      </div-->
    </SearchSort>
  <Pager PageSize="40"
    MaxPageNumButtons="9"
    PageNumCssClass="page-link"
    LastPageCssClass="page-link"
    NextPageCssClass="page-link"
    ShowTopPager="True"
    ShowBottomPager="True"
    FirstPageCaption="First"
    NextPageCaption="&raquo;"
    PrevPageCaption="&laquo;"
    LastPageCaption="Last"
    ShowFirstLast="True">
    <div class="row my-4">
      <div class="col">
        <div class="pager">
          <div class="pagination">{Pager}</div>
          <div class="pager-info"><small>Page <strong>{PageNumber}</strong> of {PageCount}</small></div>
        </div>
      </div>
    </div>
  </Pager>  
  
  
  <HeaderTemplate>
    <style type="text/css">
      .pagination a:hover{text-decoration:none!important;}
      .page-link {padding: 0.5rem .75rem 0.25rem;line-height: 20px;min-width: 40px;}
      
      .nfda-table-head {background-color: #009FD7!important; color:#FFFFFF!important; font-weight:bold; padding: 0.75rem;}
      .nfda-table-head th {color:#FFFFFF!important;}

      .supplierLogo {max-width:32px; max-height:32px;}
      
    <xmod:Select>
      <Case CompareType="text" Value='[[Url:s]]' Operator="=" Expression="1">      
      		.showClearBtn {display:inline-block!important}
    	</Case>
    </xmod:Select>
    </style>
    <table class="table table-sm table-stripedREM">
      <thead>
        <tr class="nfda-table-head">
          <th></th>
          <th>
            Name
          </th>
          <th>
            Location
          </th>
          <th>
            Categories
          </th>
          <th> </th>
        </tr>
      </thead>
      <tbody>
  </HeaderTemplate>
  <ItemTemplate>
        <tr>
          <td>
            
           <xmod:Select>
                <Case CompareType="text" Value='[[Logo]]' Operator="<>" Expression="">
                      <img src="https://portal.nfda.org/Portals/0/assets/images/account/[[Logo]]" class="supplierLogo"/>
                </Case>
            </xmod:Select>   
            
          </td>
      		<td>
            
						<xmod:DetailLink AlternateText="Details Including Categories" style="width:32px; height:32px;" text='[[Name]]'>
              <Parameter Name="AccountNumber" Value='[[AccountNumber]]' />
            </xmod:DetailLink>
            
          </td>
          
          <td>
            	<!-- [[Country]] -->
              <xmod:Select>
                <Case CompareType="text" Value='[[Country]]' Operator="<>" Expression="">      
                    [[Country]] 
                </Case>                
                <Case CompareType="text" Value='[[Country]]' Operator="=" Expression="US">      
                    [[City]], [[State]]
                </Case>
                <else>
                		[[City]], [[State]]
                </else>
              </xmod:Select>            
            
                      
          </td>
          <td>[[AssociatedCategories]]</td>
          <td>
              <xmod:DetailLink Text=">" AlternateText="View NFDA Supplier Details">
                <Parameter Name="AccountNumber" Value='[[AccountNumber]]' />
              </xmod:DetailLink>            
          </td>

        </tr>
  </ItemTemplate>
  <FooterTemplate>
      </tbody>
    </table>
  </FooterTemplate>
  <NoItemsTemplate>
      <style>
        .showClearBtn {display:inline-block!important}
      </style>    
    	<div class="alert alert-warning" style="margin:28px; padding:28px; text-align:center;">
        <h2>
          No Search Results Found
        </h2>
        <p>
          The selected search parameters returned no results. Please clear your search and try again with new names or categories selected.
        </p>
    </div>
  </NoItemsTemplate>

  <DetailTemplate>
    <style type="text/css">
      .pagination a:hover{text-decoration:none!important;}
      .page-link {padding: 0.5rem .75rem 0.25rem;line-height: 20px;min-width: 40px;}
      
      .nfda-table-head {background-color: #009FD7!important; color:#FFFFFF!important; font-weight:bold; padding: 0.75rem;}
      .nfda-table-head th {color:#FFFFFF!important;}

      .supplierLogo {max-width:332px; max-height:332px;}
    </style>
    
    
    <div>
           <xmod:Select>
                <Case CompareType="text" Value='[[Logo]]' Operator="<>" Expression="">
                      <img src="https://portal.nfda.org/Portals/0/assets/images/account/[[Logo]]" class="supplierLogo"/>
                </Case>
            </xmod:Select>      
      
      <h1>
        [[Name]]
      </h1>


<dl class="row">
  [--
    <!-- AccountNumber -->
    <dt class="col-2">
        <strong>Account Number</strong>
    </dt>
    <dd class="col-10">
        [[AccountNumber]]
    </dd>
 	--]


    <!-- Address -->
    <dt class="col-2">
        Address
    </dt>
    <dd class="col-10">
        <div class="row">
            <div class="col-12">[[StreetAddress1]]</div>
            <div class="col-12">[[City]], [[State]]</div>
            <div class="col-12">[[PostalCode]]</div>
        </div>
    </dd>

  [--
    <dt class="col-2">
        <strong>Primary Contact</strong>
    </dt>
    <dd class="col-10">
        [[PrimaryContact]]
    </dd>
  --]

    <dt class="col-2">
        <strong>Phone</strong>
    </dt>
    <dd class="col-10">
        [[Phone]]
    </dd>

    <dt class="col-2">
        <strong>Email</strong>
    </dt>
    <dd class="col-10">
        <a href="mailto:[[Email]]">[[Email]]</a>
    </dd>        

    <dt class="col-2">
        <strong>Website</strong>
    </dt>
    <dd class="col-10">
        <a href="[[Website]]" target="_blank">[[Website]]</a>
    </dd>        

    <dt class="col-2">
        <strong>&nbsp;</strong>
    </dt>
    <dd class="col-10">
        &nbsp;
    </dd>  

    <dt class="col-2">
        <strong>Associated Categories</strong>
    </dt>
    <dd class="col-10">
        <a href="[[Website]]" target="_blank">[[AssociatedCategories]]</a>
    </dd>      


</dl>

[--

        id
        ,AccountNumber
        ,Name
        ,Type
        ,StreetAddress1
        ,City
        ,State
        ,PostalCode
        ,Country
        ,AddressComposite
        ,Latitude
        ,Longitude
        ,PrimaryContact
        ,Website
        ,Email
        ,Phone
        ,NfdaInternationShipper
        ,NfdaSponsorshipLevel
        ,Category
        --Attributes
--]


      <br />&nbsp;<br/>
      <br />&nbsp;<br/>
      
      <xmod:ReturnLink CssClass="dnnSecondaryAction" Text="&lt;&lt; Return" />    
      <br />&nbsp;<br/>
            
  </div>
  </DetailTemplate>
</xmod:Template>