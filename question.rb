class Docs::Models::Question
  include Swagger::Blocks
  swagger_schema :Question do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    
    property :text do
      key :type, :string
    end
    
    property :number do
      key :type, :integer
      key :format, :int64
    end
    
    property :field_id do
      key :type, :integer
      key :format, :int64
    end
    
    property :include_attachment do
        key :type, :boolean
    end
    
    property :field do
      property :id do
        key :type, :integer
        key :format, :int64
      end
      
      property :name do
        key :type, :string
      end
      
      property :model_type do
        key :type, :string
      end
      
      property :field_type do
        key :type, :string
      end
      
      property :options do
        key :type, :string
      end
      
      property :created_at do
        key :type, :string
      end
      
      property :updated_at do
        key :type, :string
      end
      
      property :field_category do
        key :type, :string
      end
      
      property :searchable do
        key :type, :boolean
      end
      
      property :filerable do
        key :type, :boolean
      end
      
      property :unit do
        key :type, :string
      end
      
      property :aggregation do
        key :type, :string
      end
      
      property :measurable do
        key :type, :boolean
      end
      
      property :pack_id do
        key :type, :integer
        key :format, :int64
      end
      
      property :intended_type do
        key :type, :string
      end
      
      property :internal_type do
        key :type, :string
      end
      
      property :field_options do
        key :type, :array
        items do
          property :key do
            key :type, :string
          end
        end
      end
    end
  end
end