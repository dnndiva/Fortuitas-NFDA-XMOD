<AddForm>
     <SelectCommand CommandText="SELECT 
								 								@passedSearch as Search
                                 ,@passedCategory AS CategoryDropDown
                                 ,@passedCategory AS Category
   	">
        <parameter name="passedSearch" value='[[Url:search]]' datatype="string" />
        <parameter name="passedCategory" value='[[Url:category]]' datatype="string" />       
    </SelectCommand>
  	<SubmitCommand CommandText="SELECT GETDATE() AS currentdate" />

    <ControlDataSource Id="dsCategories"
      CommandText="
        -- SELECT DISTINCT Category FROM NFDA_Supplier WHERE NOT(Category = '')
        SELECT DISTINCT SupplierCategoryName AS Category FROM NFDA_Supplier_Category_XREF
      " 
    />        

  <style>
    div.ResourceSearch .ResourceSearchRight{color:white;width: 50%;float: right;}
    div.ResourceSearch .ResourceSearchLeft{margin-right: 20px;}
    div.ResourceSearch {background: #F8F8F8;margin: 0 auto;padding: 20px;}
    div.ResourceSearch Input{width:92%; margin-bottom: 20px;height: 34px;border: none;border-radius: 25px;margin-top: 20px;padding-left: 20px; float:left;}
    div.ResourceSearch .PrimaryAction{background: white;text-decoration: none;font-size: 24px;padding: 5px 10px;float: right;}
  
    .showClearBtn {display:none;}
  </style>
  
  <div class="ResourceSearch row mb-4">
    
      <div class="col-12 pt-2">
        <h3 class="mb-2">
          Search For NFDA Suppliers
        </h3>
      </div>
    
      <div class="col-lg-4 mb-3">
        <div>    
            Browse the newest Suppliers added to the NFDA Supplier Directory on this page or SEARCH to find the resource you need. 
        </div>
      </div>
    
      <div class="col-lg-8 mb-b-2 mb-lg-0">
        <div class="row flex-column">

          <div class="col-12 mb-3">
            <TextBox Id="Search" Class="form-control w-100 m-0" DataField="Search" Placeholder="Enter Keyword..." DataType="string" />
          </div>
          
          <div class="col-12">          
            <div class="form-row">
              
              <div class="col-12 col-md mb-3 mb-md-0">      
                <DropDownList Id="CategoryDropDown" Class="form-control w-100" DataField="CategoryDropDown" DataSourceId="dsCategories" DataTextField="Category" DataValueField="Category" DataType="string" AppendDataBoundItems="True">
                  <ListItem Value="">- Select Category -</ListItem>
                </DropDownList>  
              </div>
              
              <div class="col-auto">      
                 <AddLink class="dnnPrimaryAction m-0" Text="Search" Redirect="/test-fortuitas/supplier-directory?search=[[Search]]&s=1&category=[[CategoryDropDown]]" redirectMethod="Get"/>
                 <a href="/test-fortuitas/supplier-directory/" class="showClearBtn dnnSecondaryAction m-0">Clear</a>
              </div>
              
            </div>
          </div>


        </div>
      </div>
  
  </div>

  
</AddForm>

