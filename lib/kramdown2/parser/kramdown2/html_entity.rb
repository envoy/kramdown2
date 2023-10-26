# -*- coding: utf-8; frozen_string_literal: true -*-
#
#--
# Copyright (C) 2009-2019 Thomas Leitner <t_leitner@gmx.at>
#
# This file is part of kramdown2 which is licensed under the MIT.
#++
#

require 'kramdown2/parser/html'

module Kramdown2
  module Parser
    class Kramdown2

      # Parse the HTML entity at the current location.
      def parse_html_entity
        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size
        begin
          value = ::Kramdown2::Utils::Entities.entity(@src[1] || (@src[2]&.to_i) || @src[3].hex)
          @tree.children << Element.new(:entity, value,
                                        nil, original: @src.matched, location: start_line_number)
        rescue ::Kramdown2::Error
          @tree.children << Element.new(:entity, ::Kramdown2::Utils::Entities.entity('amp'),
                                        nil, location: start_line_number)
          add_text(@src.matched[1..-1])
        end
      end
      define_parser(:html_entity, Kramdown2::Parser::Html::Constants::HTML_ENTITY_RE, '&')

    end
  end
end
