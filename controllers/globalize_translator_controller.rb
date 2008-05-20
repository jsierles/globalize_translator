class GlobalizeTranslatorController < ActionController::Base
  
  self.template_root = File.join(RAILS_ROOT, 'vendor/plugins/globalize_translator/views')
  include Globalize
  
  def index
    @lang_id = params[:language] || Language.pick('en').id.to_s
    Locale.set(Language.find(@lang_id).iso_639_1)
    @view_translations = ViewTranslation.find(:all, 
       :conditions => [ 'language_id = ?', Locale.language.id, false ], :order => 'tr_key')
  end

  def translation_text
    @translation = ViewTranslation.find(params[:id])
    render :text => @translation.text || ""  
  end
  
  def update_set
    params["tr"].each { |k, v| ViewTranslation.find(k.to_i).update_attribute(:text, v) unless v.blank? }
    redirect_to :back
  end

  def set_translation_text
    @translation = ViewTranslation.find(params[:id])
    previous = @translation.text
    @translation.text = params[:value]
    @translation.text = previous unless @translation.save
    render :partial => "translation_text", :object => @translation.text  
  end
  
end
