using System.Collections.Generic;

//Atom for Clamping width to zero
namespace TexDrawLib.Core
{
    public class ClapAtom : InlineAtom
    {
        public float alignment = 0;

        public static ClapAtom Get()
        {
            return ObjPool<ClapAtom>.Get();
        }

        static public readonly Dictionary<string, float> alignments = new Dictionary<string, float>() {
            { "mathrlap", 1 },
            { "mathclap", 0.5f },
            { "mathllap", 0 },   
            { "rlap", 1 },
            { "clap", 0.5f },
            { "llap", 0 },
        };

        public override void ProcessParameters(string command, TexParserState state, string value, ref int position)
        {
            alignments.TryGetValue(command, out this.alignment);
            this.atom = state.parser.ParseToken(value, state, ref position) ?? SpaceAtom.Empty;
        }

        public override Box CreateBox(TexBoxingState state)
        {
            if (this.atom == null)
                return StrutBox.Empty;
            var baseBox = this.atom.CreateBox(state);
            var result = HorizontalBox.Get();

            result.Add(StrutBox.Get((-baseBox.width) * (1-alignment), 0, 0)); 
            result.Add(baseBox);
            result.Add(StrutBox.Get((-baseBox.width) * alignment, 0, 0));
            return result;
        }

        public override void Flush()
        {
            ObjPool<ClapAtom>.Release(this);
            base.Flush();
        }
    }

    public class SmashAtom : InlineAtom
    {
        public static SmashAtom Get()
        {
            return ObjPool<SmashAtom>.Get();
        }

        public override void ProcessParameters(string command, TexParserState state, string value, ref int position)
        {
            this.atom = state.parser.ParseToken(value, state, ref position) ?? SpaceAtom.Empty;
        }

        public override Box CreateBox(TexBoxingState state)
        {
            if (this.atom == null)
                return StrutBox.Empty;
            var baseBox = this.atom.CreateBox(state);
            var result = VerticalBox.Get();

            result.Add(StrutBox.Get(0, -baseBox.height, 0));
            result.Add(baseBox);
            result.Add(StrutBox.Get(0, -baseBox.depth, 0));
            return result;
        }

        public override void Flush()
        {
            ObjPool<SmashAtom>.Release(this);
            base.Flush();
        }
    }

    public class PhantomAtom : InlineAtom
    {

        static public readonly List<string> modes = new List<string>() {
            "phantom",
            "hphantom",
            "vphantom",
        };

        string mode;
        public static PhantomAtom Get()
        {
            return ObjPool<PhantomAtom>.Get();
        }

        public override void ProcessParameters(string command, TexParserState state, string value, ref int position)
        {
            this.mode = command;
            this.atom = state.parser.ParseToken(value, state, ref position);
        }

        public override Box CreateBox(TexBoxingState state)
        {
            if (this.atom == null)
                return StrutBox.Empty;

            var baseBox = this.atom.CreateBox(state);
            var result = StrutBox.Get(baseBox.width, baseBox.height, baseBox.depth);
            baseBox.Flush();

            if (mode == "vphantom")
            {
                result.width = 0;
            }
            else if (mode == "hphantom")
            {
                result.height = 0;
                result.depth = 0;
            }

            return result;
        }

        public override void Flush()
        {
            ObjPool<PhantomAtom>.Release(this);
            mode = "";
            base.Flush();
        }
    }
}
