class Backend::BackendController < ApplicationController
  before_filter :load_roots

private
  def load_roots
    @roots = Page.roots
  end
end