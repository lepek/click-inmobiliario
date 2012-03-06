$(document).ready(function() {
  $('#tabs').tabs({cookie: {expires: 1}});
  $("#currencies-table").currenciesTable();
  $("#locations-table").locationsTable();
  $("#operations-table").operationsTable();
  $("#properties-table").propertiesTable();
  $("#real_estates-table").real_estatesTable();
  $("#types-table").typesTable();
  $("#users-table").usersTable();
  $("#poi-types-table").poiTypesTable();
  $("#pois-table").poisTable();
});

(function($) {
  /**
   * A column with default values.
   */
  var standardColumn = null;
  
  /**
   * A hidden column.
   */
  var hiddenColumn = {
    bSearchable: false,
    bSortable: false,
    bVisible: false
  }
  
  /**
   * A column that holds action buttons.
   */
  var actionColumn = {
    bSearchable: false,
    bSortable: false,
    sWidth: "65px"
  };
  
  var nameColumn = {
    sWidth: "150px"
  };
  
  var shortNameColumn = {
    sWidth: "70px"
  };
  
  var countColumn = {
    bSearchable: false,
    sWidth: "50px"
  };
  
  $.fn.selectableTable = function(tableOptions) {
    // Set the options that all of them share
    tableOptions.iDisplayLength = 10;
    tableOptions.bAutoWidth = false;
    tableOptions.bJQueryUI = true;
    tableOptions.bSort = true;
    tableOptions.bLengthChange = true;
    tableOptions.bStateSave = true;
    tableOptions.sPaginationType = "full_numbers";
    
    return this.dataTable(tableOptions);
  }
  
  $.fn.currenciesTable = function() {
    var tableOptions = {
      aoColumns: [
        nameColumn, // Moneda
        nameColumn, // Codigo
        actionColumn // Action buttons
      ]
    };
    return this.selectableTable(tableOptions);
  };
  
  $.fn.usersTable = function() {
    var tableOptions = {
      aoColumns: [
        nameColumn, // Nombre
        nameColumn, // email
        shortNameColumn, // rol
        actionColumn // Action buttons
      ]
    };
    return this.selectableTable(tableOptions);
  };
  
  $.fn.locationsTable = function() {
    var tableOptions = {
      aoColumns: [
        nameColumn, // Localidad
        actionColumn // Action buttons
      ]
    };
    return this.selectableTable(tableOptions);
  };
  
  $.fn.operationsTable = function() {
    var tableOptions = {
      aoColumns: [
        nameColumn, // Operacion
        actionColumn // Action buttons
      ]
    };
    return this.selectableTable(tableOptions);
  };  

  $.fn.propertiesTable = function() {
    var tableOptions = {
      aoColumns: [
        countColumn, // Codigo
        nameColumn, // Direccion
        shortNameColumn, // Localidad
        shortNameColumn, // Tipo
        shortNameColumn, // Inmobiliaria
        actionColumn // Action buttons
      ]
    };
    return this.selectableTable(tableOptions);
  };

  $.fn.real_estatesTable = function() {
    var tableOptions = {
      aoColumns: [
        nameColumn, // Inmobiliaria
        nameColumn, // E-mail
        actionColumn // Action buttons
      ]
    };
    return this.selectableTable(tableOptions);
  };

  $.fn.typesTable = function() {
    var tableOptions = {
      aoColumns: [
        nameColumn, // Tipo de inmueble
        actionColumn // Action buttons
      ]
    };
    return this.selectableTable(tableOptions);
  };
  
  $.fn.poiTypesTable = function() {
    var tableOptions = {
      aoColumns: [
        nameColumn, // Tipo de punto de interes
        actionColumn // Action buttons
      ]
    };
    return this.selectableTable(tableOptions);
  };
  
  $.fn.poisTable = function() {
    var tableOptions = {
      aoColumns: [
        nameColumn, // Descripcion
        nameColumn, // Direccion
        shortNameColumn, // Localidad
        shortNameColumn, // Tipo de Punto de Interes
        actionColumn // Action buttons
      ]
    };
    return this.selectableTable(tableOptions);
  };
 
})(jQuery);
