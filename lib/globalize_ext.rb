module Globalize

  @@translation_mode = false
  @@request_translations = []
  mattr_accessor :translation_mode
  mattr_accessor :request_translations

  class Language
    def self.select_options(field = 'english_name', value = 'iso_639_1')
      self.find(:all, :order => field).collect { |x| [x.send(field.to_sym), x.send(value.to_sym)] }
    end
  end
  class DbViewTranslator
    def fetch_view_translation(key, language, idx, namespace = nil)
      tr = nil
      ViewTranslation.transaction do
        tr = ViewTranslation.pick(key, language, idx, namespace)

        # fill in a nil record for missed translations report
        # do not report missing zero-forms -- they're optional
        if !tr && idx != 0
          tr = ViewTranslation.create!(:tr_key => key,
            :language_id => language.id, :pluralization_index => idx,
            :text => nil, :namespace => namespace)
        end
      end
      # patched to support translation_mode - collect this request's translations and store them in a module variable unless it's a built-in translation
      if tr
        ::Globalize.request_translations << tr unless ::Globalize.request_translations.include?(tr)
        return tr.text
      else
        return nil
      end
    end

    private
    def fetch_from_cache(key, language, real_default, num, namespace = nil)
      return real_default if language.nil?

      zero_form   = num == 0
      plural_idx  = language.plural_index(num)        # language-defined plural form
      zplural_idx = zero_form ? 0 : plural_idx # takes zero-form into account

      cached = cache_fetch(key, language, zplural_idx, namespace)
      if !::Globalize.translation_mode && cached
        result = cached
      else
        result = fetch_view_translation(key, language, zplural_idx, namespace)

        # set to plural_form if no zero-form exists
        result ||= fetch_view_translation(key, language, plural_idx, namespace) if zero_form

        cache_add(key, language, zplural_idx, result, namespace)
      end
      result ||= real_default
    end
  end
end
