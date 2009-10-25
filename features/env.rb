require 'cucumber/ast/step_invocation'

module Cucumber
  module Ast
    class StepInvocation #:nodoc:
      def invoke(step_mother, options)
        find_step_match!(step_mother)
        unless @skip_invoke || options[:dry_run] || @exception || @step_collection.exception
          @skip_invoke = true
          begin
            @step_match.invoke(@multiline_arg)
            step_mother.after_step
            status!(:passed)
          rescue Pending => e
            failed(options, e, false)
            status!(:pending)
          rescue Undefined => e
            failed(options, e, false)
            status!(:undefined)
          rescue Cucumber::Ast::Table::Different => e
            @different_table = e.table
            failed(options, e, false)
            status!(:failed)
          rescue SystemExit => e
            raise
          rescue Exception => e
            failed(options, e, false)
            status!(:failed)
          end
        end
      end
    end
  end
end

