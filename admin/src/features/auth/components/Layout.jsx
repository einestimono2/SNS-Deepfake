import { Head } from '#/common/components';

export function Layout({ children, title }) {
  return (
    <>
      <Head title={title} />

      <div className="min-h-screen bg-gray-500 flex justify-center items-center">
        <div className="flex-col px-12 py-8 w-[30%] border-solid border-2 border-[rgba(255,255,255,0.1)] rounded-[20px] z-10 bg-[rgba(255,255,255,0.25)] backdrop-blur-md shadow-[0_0_40px_0_rgba(8,7,16,0.6)]">
          {children}
        </div>
      </div>
    </>
  );
}
