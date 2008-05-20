Event.addBehavior({
  "#translate-toggle:click" : function(event) { translator.showCenter(); Event.stop(event); },
  "body" : function() {
    header = 'Translations';
    translator = new Window({className: "alphacube", title: header, width:500, height:500, recenterAuto:false});
    //strings = $$(".translated");
    content = translations.inject('', function(html, tr){    
      return html + '<tr><td width="20%">'+ tr.attributes.tr_key +'</td><td width="80%"><input type="text" name="tr['+tr.attributes.id+']" value="'+(tr.attributes.text || "")+'" /></td><td>'+tr.attributes.pluralization_index+'</td></tr>'; 
    });
    translator.setHTMLContent('<form action="/globalize_translator/update_set" method="post"><table width="100%" cellspacing="2"><tr><th>Base</th><th>Translation</th><th>Qty</th></tr>'
    +content+"</table><button>Save Changes</button></form>");
    translator.showCenter();
  }
});
