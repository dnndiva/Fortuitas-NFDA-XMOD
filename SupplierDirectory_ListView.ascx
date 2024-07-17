<xmod:Select>
  <Case CompareType="text" Value='[[Url:search]]' Operator="<>" Expression="">          
      <div class="showClearBtn pt-3 pb-2 px-3 bg-navy w-100 mb-4">
        <h2 class="lead m-0 text-white">Searching: 
          [[Url:search]] 
          <xmod:Select>
            <Case CompareType="text" Value='[[Url:category]]' Operator="<>" Expression="">           
              - [[Url:category]]
            </Case>
          </xmod:Select>
        </h2>    
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
      SearchLabelText="Supplier Search Results" SearchButtonText="GO"
      SortFieldNames="Name,City,State,NfdaSponsorshipLevel,logo,phone,email,website"
      SortFieldLabels="Name,City,State,Sponsorship Level,logo,phone,email,website"
      SearchBoxCssClass="form-control"
      SearchButtonCssClass="btn btn-blue"
      SortButtonText="Go"
      SortButtonCssClass="btn btn-default"
      SortFieldListCssClass="form-control">
  		<div class="row align-items-center">
        <div class="col-12 col-lg mb-mr-auto">
        	<h3 class="m-lg-0">{SearchLabel}</h3>    
        </div>    
        <div class="col-auto">

          <div class="row align-items-center">
            <div class="col-12 col-sm-auto mb-2 mb-sm-0">
              <div class="d-flex form-gap flex-nowrap align-items-center">
                <label class="control-label">Sort</label>
                {SortFieldList}
                {SortButton}
              </div>           
            </div>            
            <div class="col-auto">
              <div class="checkbox">
                <label>
                  {ReverseSort} Reverse
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
    MaxPageNumButtons="5"
    PageNumCssClass="page-link-box"
    LastPageCssClass="page-link-box"
    NextPageCssClass="page-link-box"
    ShowTopPager="True"
    ShowBottomPager="True"
    FirstPageCaption="First"
    NextPageCaption="&raquo;"
    PrevPageCaption="&laquo;"
    LastPageCaption="Last"
    ShowFirstLast="True">
    <div class="pager row align-items-center mx-0 mt-3 py-1">
      <div class="pagination col-12 col-sm mr-auto">{Pager}</div>
      <div class="pager-info font-sime-small my-2">Page <strong>{PageNumber}</strong> of {PageCount}</div>
    </div>
  </Pager>  
  
  
  <HeaderTemplate>
    <style type="text/css">
      .pagination a:hover{text-decoration:none!important;}
      .CommandButton,
      .page-link-box {
          padding: 7px 12px 2px;
          text-decoration: none !important;
          background-color: #FFF;
          color: #777;
          display: inline-block;
          margin: 0 4px 0 0;
          font-size: 18px;
      }
      .CommandButton:hover,
      .page-link-box:hover {
          background-color: #EEE;
      }
      span.page-link-box[style="font-weight:bold;"] {
          background-color: #EEE;
          color: #444;
      }
      
      .nfda-table-head {background-color: #009FD7!important; color:#FFFFFF!important; font-weight:bold; padding: 0.75rem;}
      .nfda-table-head th {color:#FFFFFF!important;}

      .supplierLogo {width:100px;}
      
      /* this Bootstrap version doesn't have stretched link */
      .stretched-link:after {
          position: absolute;
          top: 0;
          right: 0;
          bottom: 0;
          left: 0;
          z-index: 1;
          content: "";
      }
      .stretched-link:hover:after {
        background-color:rgba(0, 159, 215,0.05);
      }
      
      .zebra-rows:nth-child(even) {
        background-color:#FFF;
      }
      .zebra-rows:nth-child(odd) {
        background-color:#e8edef;
      }

      .form-gap {
        gap:0.75rem;
      }

      <xmod:Select>
        <Case CompareType="text" Value='[[Url:s]]' Operator="=" Expression="1">      
            .showClearBtn {display:inline-block!important}
        </Case>
      </xmod:Select>
    </style>

    <div class="suppliers-directory">
      <div class="p-1 mt-4 bg-blue d-block d-md-none"></div>
      <div class="row mt-4 mx-0 bg-blue d-none d-md-flex">
        <div class="col-md-3 text-white pt-3 pb-2">
            Name
        </div>
        <div class="col-md-3 text-white pt-3 pb-2">
            Location
        </div>
        <div class="col-md text-white pt-3 pb-2">
            Categories
        </div>
      </div>

  </HeaderTemplate>

  <ItemTemplate>
  
      <div class="row m-0 position-relative zebra-rows">
        <xmod:DetailLink Text="" AlternateText="View NFDA Supplier Details" Class="stretched-link">
          <Parameter Name="AccountNumber" Value='[[AccountNumber]]'/>
        </xmod:DetailLink>
        <div class="col-md-3 pt-3 pt-md-2 pb-1">
            <small class="strong text-blue uppercase opacity-50 mb-half d-block d-md-none">Name</small>
            <xmod:DetailLink AlternateText="Details Including Categories" style="width:32px; height:32px;" text='[[Name]]'>
              <Parameter Name="AccountNumber" Value='[[AccountNumber]]' />
            </xmod:DetailLink>
        </div>
        <div class="col-md-3 pt-2 pb-1">
          <small class="strong text-blue uppercase opacity-50 mb-half d-block d-md-none">Location</small>
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
        </div>
        <div class="col-md pt-2 pb-1">
          <small class="strong text-blue uppercase opacity-50 mb-half d-block d-md-none">Categories</small>
          [[AssociatedCategories]]
        </div>
        <div class="col-md-1 py-2">
          <xmod:Select>
            <Case CompareType="text" Value='[[Logo]]' Operator="<>" Expression="">
              <img src="https://portal.nfda.org/Portals/0/assets/images/account/[[Logo]]" class="supplierLogo"/>
            </Case>
          </xmod:Select>
        </div>
      </div>
  </ItemTemplate>

  <FooterTemplate>

    </div>
  </FooterTemplate>

  <NoItemsTemplate>
      <style type="text/css">
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
      .nfda-table-head {background-color: #009FD7!important; color:#FFFFFF!important; font-weight:bold; padding: 0.75rem;}
      .nfda-table-head th {color:#FFFFFF!important;}
      .supplier-detail {padding: 28px 34px;}

      .supplierLogo {width:200px;}
    </style>
    
    
    <div class="supplier-detail border">
      <div class="row">
        <div class="col order-1">
          <h2>
            [[Name]]
          </h2>

            [--
            <div class="row mt-2">
              <!-- AccountNumber -->
              <div class="col-12 col-md-3 col-lg-2">
                  <strong>Account Number</strong>
              </div>
              <div class="col-10">
                  [[AccountNumber]]
              </div>
            </div>
            --]


            <!-- Address -->
            <div class="row mt-2">
              <div class="col-12 col-md-3 col-lg-2">
                  <strong>Address</strong>
              </div>
              <div class="col">
                  <div class="row">
                      <div class="col-12">[[StreetAddress1]]</div>
                      <div class="col-12">[[City]], [[State]]</div>
                      <div class="col-12">[[PostalCode]]</div>
                  </div>
              </div>
            </div>

            [--
            <div class="row mt-2">
              <div class="col-12 col-md-3 col-lg-2">
                  <strong>Primary Contact</strong>
              </div>
              <div class="col">
                  [[PrimaryContact]]
              </div>
            </div>
            --]

            <div class="row mt-2">
              <div class="col-12 col-md-3 col-lg-2">
                  <strong>Phone</strong>
              </div>
              <div class="col">
                  [[Phone]]
              </div>
            </div>

            <div class="row mt-2">
              <div class="col-12 col-md-3 col-lg-2">
                  <strong>Email</strong>
              </div>
              <div class="col">
                  <a href="mailto:[[Email]]">[[Email]]</a>
              </div>    
            </div>    

            <div class="row mt-2">
              <div class="col-12 col-md-3 col-lg-2">
                  <strong>Website</strong>
              </div>
              <div class="col">
                  <a href="[[Website]]" target="_blank">[[Website]]</a>
              </div> 
            </div>  

            <div class="row mt-4 mb-3">
              <div class="col-12">
                  <strong>Associated Categories</strong>
              </div>
              <div class="col">
                  [[AssociatedCategories]]
              </div>
            </div>

            <div class="row">
              <div class="col">
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
                <hr class="my-2">
                <xmod:ReturnLink CssClass="btn btn-blue mt-3" Text="<em class='fa fa-chevron-left fa-sm pr-2'></em>Back to List" />
              </div>
            </div>
            
        </div>

        <div class="col-12 col-sm-auto order-0 order-sm-2">
          <xmod:Select>
            <Case CompareType="text" Value='[[Logo]]' Operator="<>" Expression="">
              <img src="https://portal.nfda.org/Portals/0/assets/images/account/[[Logo]]" class="supplierLogo mb-4"/>
            </Case>
          </xmod:Select>
        </div>
      </div>

            
    </div>
  </DetailTemplate>
</xmod:Template>