// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file versionedString.hpp
 *
 * @copyright Copyright (C) 2023-2024 SDML (www.srcDiff.org)
 *
 * This file is part of the srcDiff Infrastructure.
 */

#ifndef INCLUDED_VERSIONED_STRING_HPP
#define INCLUDED_VERSIONED_STRING_HPP

#include <string>
#include <iostream>

#include <optional>
#include <cassert>

enum diffOperation { COMMON, DELETE, INSERT, NONE };

class versionedString {

    private:

        static const std::string empty_str;

        std::optional<std::string> string_original;
        std::optional<std::string> string_modified;

        char separator;

    protected:

    public:
        static std::string normalize(const std::string& str, const std::string& sep);

        versionedString(char separator = '|');
        versionedString(std::string string, char separator = '|');
        versionedString(std::string string_original, std::string string_modified, char separator = '|');

        bool is_common() const;
        bool has_original() const;
        bool has_modified() const;

        std::string& original();
        const std::string& original() const;
        std::string& modified();
        const std::string& modified() const;
        const std::string& first_active_string() const;

        void set_original(const std::string& string_original);
        void set_modified(const std::string& string_modified);
        void append(const std::string& str, diffOperation version);
        void append(const char * characters, size_t len, diffOperation version);
        void clear();

        std::size_t find(const std::string&) const;

        versionedString remove_spaces() const;
        versionedString normalize_spaces() const;

        void swap(versionedString & other);

        operator std::string() const;
        bool operator==(const std::string& str) const;
        bool operator!=(const std::string& str) const;
        bool operator==(const char * c_str) const;
        bool operator!=(const char * c_str) const;
        bool operator<(const versionedString & v_str) const;
        std::string operator+(const std::string& str) const;
        std::string operator+(const char * c_str) const;
        versionedString operator+(const versionedString & v_str) const;

        versionedString & operator+=(const versionedString & v_str);

        friend std::ostream & operator<<(std::ostream & out, const versionedString & string);
        friend std::string operator+(const std::string& str, const versionedString & v_str);
        friend std::string operator+(const char * c_str, const versionedString & v_str);

};



#endif
