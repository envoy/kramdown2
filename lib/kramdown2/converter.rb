# -*- coding: utf-8; frozen_string_literal: true -*-
#
#--
# Copyright (C) 2009-2019 Thomas Leitner <t_leitner@gmx.at>
#
# This file is part of kramdown2 which is licensed under the MIT.
#++
#

require 'kramdown2/utils'

module Kramdown2

  # This module contains all available converters, i.e. classes that take a root Element and convert
  # it to a specific output format. The result is normally a string. For example, the
  # Converter::Html module converts an element tree into valid HTML.
  #
  # Converters use the Base class for common functionality (like applying a template to the output)
  # \- see its API documentation for how to create a custom converter class.
  module Converter

    autoload :Base, 'kramdown2/converter/base'
    autoload :Html, 'kramdown2/converter/html'
    autoload :Latex, 'kramdown2/converter/latex'
    autoload :Kramdown2, 'kramdown2/converter/kramdown2'
    autoload :Toc, 'kramdown2/converter/toc'
    autoload :RemoveHtmlTags, 'kramdown2/converter/remove_html_tags'
    autoload :HashAST, 'kramdown2/converter/hash_ast'
    autoload :HashAst, 'kramdown2/converter/hash_ast'
    autoload :Man, 'kramdown2/converter/man'

    extend ::Kramdown2::Utils::Configurable

    configurable(:syntax_highlighter)

    ['Minted', "Rouge"].each do |klass_name|
      kn_down = klass_name.downcase.intern
      add_syntax_highlighter(kn_down) do |converter, text, lang, type, opts|
        require "kramdown2/converter/syntax_highlighter/#{kn_down}"
        klass = ::Kramdown2::Utils.deep_const_get("::Kramdown2::Converter::SyntaxHighlighter::#{klass_name}")
        if !klass.const_defined?(:AVAILABLE) || klass::AVAILABLE
          add_syntax_highlighter(kn_down, klass)
        else
          add_syntax_highlighter(kn_down) { nil }
        end
        syntax_highlighter(kn_down).call(converter, text, lang, type, opts)
      end
    end

    configurable(:math_engine)

    ["Mathjax"].each do |klass_name|
      kn_down = klass_name.downcase.intern
      add_math_engine(kn_down) do |converter, el, opts|
        require "kramdown2/converter/math_engine/#{kn_down}"
        klass = ::Kramdown2::Utils.deep_const_get("::Kramdown2::Converter::MathEngine::#{klass_name}")
        if !klass.const_defined?(:AVAILABLE) || klass::AVAILABLE
          add_math_engine(kn_down, klass)
        else
          add_math_engine(kn_down) { nil }
        end
        math_engine(kn_down).call(converter, el, opts)
      end
    end

  end

end
