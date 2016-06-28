/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.opengl3.loaders.internal;

enum commonImports =
q{
    import std.array;
    import derelict.util.exception,
           derelict.util.loader,
           derelict.util.system;

    import derelict.opengl3.types,
           derelict.opengl3.loaders.glloader;

    static if(Derelict_OS_Android || Derelict_OS_iOS) {
        // Android and iOS do not support OpenGL3; use DerelictOpenGLES.
        static assert(false, "OpenGL is not supported on Android or iOS; use OpenGLES (DerelictGLES) instead");
    } else static if(Derelict_OS_Windows) {
        private enum libNames = "opengl32.dll";
    } else static if(Derelict_OS_Mac) {
        private enum libNames = "../Frameworks/OpenGL.framework/OpenGL, /Library/Frameworks/OpenGL.framework/OpenGL, /System/Library/Frameworks/OpenGL.framework/OpenGL";
    } else static if(Derelict_OS_Posix) {
        private enum libNames = "libGL.so.1,libGL.so";
    } else
        static assert(0, "Need to implement OpenGL libNames for this operating system.");
};

enum commonMembers =
q{
    private Appender!(const(char)*[]) _extCache;
    private GLVersion _loadedVersion;
    private GLVersion _contextVersion;

    @property @nogc nothrow
    GLVersion loadedVersion() { return _loadedVersion; }

    @property @nogc nothrow
    GLVersion contextVersion() { return _contextVersion; }

    // Assumes that name is null-terminated, i.e. a string literal
    bool isExtSupported(GLVersion glversion, string name)
    {
        import core.stdc.string : strstr;

        static if(useGL!30) {
            // If OpenGL 3+ is loaded, use the cache.
            import core.stdc.string : strcmp;
            if(glversion >= GLVersion.gl30) {
                foreach(extname; _extCache.data) {
                    if(strcmp(extname, name.ptr) == 0)
                        return true;
                }
                return false;
            }
        }

        auto cstr = glGetString(GL_EXTENSIONS);
        auto res = strstr(cstr, name.ptr);
        while(res) {
            // It's possible that the extension name is actually a
            // substring of another extension. If not, then the
            // character following the name in the extension string
            // should be a space (or possibly the null character).
            if(res[name.length] == ' ' || res[name.length] == '\0')
                return true;
            res = strstr(res + name.length, name.ptr);
        }

        return false;
    }


    static if(useGL!30) private
    void initExtensionCache()
    {
        // There's no need to cache extension names using the pre-3.0 glString
        // technique, but the modern style of using glStringi results in a high
        // number of calls when testing for every extension Derelict supports.
        // This causes extreme slowdowns when using GLSL-Debugger. The cache
        // solves that problem. Can't hurt load time, either.
        if(_loadedVersion >= GLVersion.gl30)
        {
            int count;
            glGetIntegerv(GL_NUM_EXTENSIONS, &count);

            _extCache.shrinkTo(0);
            _extCache.reserve(count);

            for(int i=0; i<count; ++i)
                _extCache.put(glGetStringi(GL_EXTENSIONS, i));
        }
    }

    private
    GLVersion getContextVersion()
    {
        /* glGetString(GL_VERSION) is guaranteed to return a constant string
         of the format "[major].[minor].[build] xxxx", where xxxx is vendor-specific
         information. Here, I'm pulling two characters out of the string, the major
         and minor version numbers. */
        auto verstr = glGetString(GL_VERSION);
        char major = *verstr;
        char minor = *(verstr + 2);

        switch(major) {
            case '4':
                if(minor == '5') return GLVersion.gl45;
                else if(minor == '4') return GLVersion.gl44;
                else if(minor == '3') return GLVersion.gl43;
                else if(minor == '2') return GLVersion.gl42;
                else if(minor == '1') return GLVersion.gl41;
                else if(minor == '0') return GLVersion.gl40;

                /* No default condition here, since it's possible for new
                 minor versions of the 4.x series to be released before
                 support is added to Derelict. That case is handled outside
                 of the switch. When no more 4.x versions are released, this
                 should be changed to return GL40 by default. */
                break;

            case '3':
                if(minor == '3') return GLVersion.gl33;
                else if(minor == '2') return GLVersion.gl32;
                else if(minor == '1') return GLVersion.gl31;
                else return GLVersion.gl30;

            case '2':
                if(minor == '1') return GLVersion.gl21;
                else return GLVersion.gl20;

            case '1':
                if(minor == '5') return GLVersion.gl15;
                else if(minor == '4') return GLVersion.gl14;
                else if(minor == '3') return GLVersion.gl13;
                else if(minor == '2') return GLVersion.gl12;
                else return GLVersion.gl11;

            default:
                /* glGetString(GL_VERSION) is guaranteed to return a result
                 of a specific format, so if this point is reached it is
                 going to be because a major version higher than what Derelict
                 supports was encountered. That case is handled outside the
                 switch. */
                break;
        }

        /* It's highly likely at this point that the version is higher than
         what Derelict supports, so return the highest supported version. */
        return GLVersion.highestSupported;
    }
};