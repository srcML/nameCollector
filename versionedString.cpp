// SPDX-License-Identifier: GPL-3.0-only
/**
 * @file versionedString.cpp
 *
 * @copyright Copyright (C) 2023-2024 SDML (www.srcDiff.org)
 *
 * This file is part of the srcDiff Infrastructure.
 */

#include "versionedString.hpp"
// TODO: is this still used?
#ifdef __linux__
    #include <execinfo.h>
#endif
#include <sstream>
#include <iterator>

const std::string versionedString::empty_str;

versionedString::versionedString(char separator)
    : string_original(), string_modified(), separator(separator) {}

versionedString::versionedString(std::string string, diffOperation version, char separator)
    : string_original(), string_modified(), separator(separator) {
        if(version != INSERT) {
            string_original = string;
        }

        if(version != DELETE) {
            string_modified = string;
        }
    }

versionedString::versionedString(std::string string_original, std::string string_modified, char separator) 
    : string_original(string_original), string_modified(string_modified), separator(separator) {}

bool versionedString::is_common() const {
    return string_original == string_modified;
}

bool versionedString::has_original() const {
    return bool(string_original);
}

bool versionedString::has_modified() const {
    return bool(string_modified);
}

std::string& versionedString::original() {
    assert(has_original());
    return *string_original;
}

const std::string& versionedString::original() const {
    if(!has_original()) return empty_str;
    return *string_original;
}

std::string& versionedString::modified() {
    assert(has_modified());
    return *string_modified;
}

const std::string& versionedString::modified() const {
    if(!has_modified()) return empty_str;
    return *string_modified;
}

const std::string& versionedString::first_active_string() const {
    if(has_original()) return original();
    if(has_modified()) return modified();
    return empty_str;
}

void versionedString::set_original(const std::string& string_original) {
    this->string_original = string_original;
}

void versionedString::set_modified(const std::string& string_modified) {
    this->string_modified = string_modified;
}

void versionedString::append(const std::string& str, diffOperation version) {
    append(str.c_str(), str.size(), version);
}

void versionedString::append(const char * characters, size_t len, diffOperation version) {

    if(len == 0) return;

    if(version != INSERT) {
        if(!bool(string_original)) string_original = std::string(characters, len);
        else string_original->append(characters, len);
    }

    if(version != DELETE) {
        if(!bool(string_modified)) string_modified = std::string(characters, len);
        else string_modified->append(characters, len);
    }

}

void versionedString::clear() {
    string_original = std::optional<std::string>();
    string_modified = std::optional<std::string>();
}

std::string versionedString::normalize(const std::string& str, const std::string& sep) {
    std::istringstream in(str);
    std::ostringstream out;
    std::copy(std::istream_iterator<std::string>(in), std::istream_iterator<std::string>(), std::ostream_iterator<std::string>(out, sep.c_str()));
    return out.str();
}

bool versionedString::equals(const std::string& str, diffOperation version) const {

    if(version == DELETE) {
        return string_original? string_original == str : false;
    }

    if(version == INSERT) {
        return string_modified? string_modified == str : false;
    }

    return std::string(*this) == str;

}
std::size_t versionedString::find(const std::string& str, diffOperation version) const {

    if(version != INSERT && string_original) {
        std::size_t pos = string_original->find(str);
        if(pos != std::string::npos) {
            return pos;
        }
    }

    if(version != DELETE && string_modified) {
        std::size_t pos = string_modified->find(str);
        if(pos != std::string::npos) {
            return pos;
        }
    }

    return std::string::npos;

}

void versionedString::erase(const std::string& str) {

    if(string_original) {
        std::size_t pos = string_original->find(str);
        if(pos != std::string::npos) {
            string_original->erase(0, pos + str.size());
        }
    }

    if(string_modified) {
        std::size_t pos = string_modified->find(str);
        if(pos != std::string::npos) {
            string_modified->erase(0, pos + str.size());
        }
    }
}

versionedString versionedString::remove_spaces() const {
    versionedString str;
    if(string_original) {
        str.string_original = normalize(*string_original, "");
    }

    if(string_modified) {
        str.string_modified = normalize(*string_modified, "");
    }

    return str;
}

versionedString versionedString::normalize_spaces() const {
    versionedString str;
    if(string_original) {
        str.string_original = normalize(*string_original, " ");
    }

    if(string_modified) {
        str.string_modified = normalize(*string_modified, " ");
    }

    return str;
}

void versionedString::swap(versionedString & other) {
    string_original.swap(other.string_original);
    string_modified.swap(other.string_modified);
}

versionedString::operator std::string() const {
    if(is_common()) return original();
    return original() + separator + modified();
}

bool versionedString::operator==(const std::string& str) const {
    return std::string(*this) == str;
}

bool versionedString::operator!=(const std::string& str) const {
    return std::string(*this) != str;
}

bool versionedString::operator==(const char * c_str) const {
    return std::string(*this) == c_str;
}

bool versionedString::operator!=(const char * c_str) const {
    return std::string(*this) != c_str;
}

bool versionedString::operator<(const versionedString & v_str) const {
    return std::string(*this) < std::string(v_str);
}

std::string versionedString::operator+(const std::string& str) const {
    return std::string(*this) + str;
}

std::string versionedString::operator+(const char * c_str) const {
    return std::string(*this) + c_str;
}

versionedString versionedString::operator+(const versionedString & v_str) const {
    versionedString new_str(*this);
    new_str += v_str;
    return new_str;
}

versionedString & versionedString::operator+=(const versionedString & v_str) {
    if(v_str.string_original) {
        append(*v_str.string_original, DELETE);
    }

    if(v_str.string_modified) {
        append(*v_str.string_modified, INSERT);
    }

    return *this;
}

std::ostream & operator<<(std::ostream & out, const versionedString & string) {
    if(string.is_common()) return out << string.original();
    else return out << string.original() << string.separator << string.modified();
}

std::string operator+(const std::string& str, const versionedString & v_str) {
    return str + std::string(v_str);
}

std::string operator+(const char * c_str, const versionedString & v_str) {
    return c_str + std::string(v_str);
}
