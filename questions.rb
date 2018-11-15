class Docs::Questions
    include Swagger::Blocks
    swagger_path '/questions' do
        operation :get do
            key :description, "Questions regarding the state of the applications"
            key :tags, ['questions']
            
            response 200 do
                key :description, "Questions retrieved successfully"
                schema do
                    key :'$ref', :Question
                end
            end
            
            response 400 do
                key :description, "Errors occured while retrieving questions"
                schema do
                    key :'$ref', :ErrorModel
                end
            end
        end
    end
end